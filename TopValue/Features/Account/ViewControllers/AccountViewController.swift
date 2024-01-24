//
//  AccountViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import WebKit
import GoogleSignIn
import AuthenticationServices

class AccountViewController: BaseViewController, WKNavigationDelegate{
    
    @IBOutlet private weak var webContainner: UIView!
    var path: String = ApplicationFlag.accountPath
    private var webView: WKWebView = WKWebView()
    private let accountViewModel = AccountViewModel()
    private var lastCurrentIndex: Int = 4
    enum LoginType : String {
        case Google = "google"
        case Apple = "apple"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        config(request: path)
        createBinding()
    }
    
    private func setupView() {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "receiveTokenLogin")
        userContentController.add(self, name: "clickLoginButton")
        userContentController.add(self, name: "clickHomeButton")
        userContentController.add(self, name: "clickCartButton")
        userContentController.add(self, name: "clickWishListButton")
        userContentController.add(self, name: "clickCategoryButton")
        userContentController.add(self, name: "clickAccountButton")
        configuration.userContentController = userContentController
        configuration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView.navigationDelegate = self
        self.webView = webView
        self.webContainner.addSubview(webView)
        self.webView.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview()
        }
    }
    
    private func config(request: String) {
        webView.isOpaque = false
        webView.scrollView.bounces = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = true
        guard let url = URL(string: request) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func createBinding() {
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(handleTabbarDidSelected),
                name: NSNotification.Name(rawValue: "tabbarDidSelected"),
                object: nil
            )
        accountViewModel
            .currentIndex
            .subscribe(onNext: { [weak self] currentIndex in
                guard let self = self else { return }
                if currentIndex == 4, self.lastCurrentIndex == 4, self.webView.url?.absoluteString != self.path {
                    self.movetoBasePath()
                }
                self.lastCurrentIndex = currentIndex
            }).disposed(by: self.disposeBag)
    }
    
    private func movetoBasePath() {
        guard let url = URL(string: path) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func handleTabbarDidSelected(_ notification: Notification) {
        if let userInfo = notification.userInfo, let selectedIndex = userInfo["selectedIndex"] as? Int {
            self.accountViewModel.currentIndex.accept(selectedIndex)
        }
    }
    
    @objc private func signInWithGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            if let googleUser = GIDSignIn.sharedInstance.currentUser {
                let idToken = googleUser.idToken
                let accessToken = googleUser.accessToken
                let email = googleUser.profile?.email
                self.sentLoginWithGoogleToWeb(loginType: .Google, email: email)
            }
        }
    }
    
    @objc private func signInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func sentLoginWithGoogleToWeb(loginType: LoginType, email: String?) {
        let script = "receiveEmailForLogin('\(loginType)', '\(email ?? "")');"
        webView.evaluateJavaScript(script) { _, error in
            if let error = error {
                print("JavaScript evaluation error: \(error.localizedDescription)")
            }
        }
    }
}
extension AccountViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed login \(error)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            case let credentials as ASAuthorizationAppleIDCredential:
                let email = credentials.email
                self.sentLoginWithGoogleToWeb(loginType: .Apple, email: email)
                break
                
            default:
                break
                
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
   
}

extension AccountViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "receiveTokenLogin", let messageBody = message.body as? String {
            print("Received message from JavaScript: \(messageBody)")
            UserDefaults.standard.set(messageBody, forKey: "userLoginToken")
        } else if message.name == "clickLoginButton", let messageBody = message.body as? String {
            if messageBody == LoginType.Google.rawValue {
                self.signInWithGoogle()
            } else if messageBody == LoginType.Apple.rawValue {
                self.signInWithApple()
            }
        } else if message.name == "clickHomeButton" {
            viewModel.navigateToHome()
        } else if message.name == "clickCartButton" {
            viewModel.navigateToCart()
        } else if message.name == "clickWishListButton" {
            viewModel.navigateToWishList()
        } else if message.name == "clickCategoryButton" {
            viewModel.navigateToCategory()
        } else if message.name == "clickAccountButton" {
            viewModel.navigateToAccount()
        }
    }
}
