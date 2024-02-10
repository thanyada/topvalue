//
//  BaseViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import RxDataSources
import RxSwift
import RxWKWebView
import SnapKit
import WebKit
import GoogleSignIn
import AuthenticationServices

class BaseViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView = WKWebView()
    var disposeBag: DisposeBag = DisposeBag()
    var viewModel = BaseViewModel()
    var actionType: BaseViewModel.ActionType?
    let baseWebView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupWebView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTabBar), name: NSNotification.Name(rawValue: "showTabbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTabBar), name: NSNotification.Name(rawValue: "hideTabbar"), object: nil)
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "receiveTokenLogin")
        userContentController.add(self, name: "clickLoginButton")
        userContentController.add(self, name: "clickHomeButton")
        userContentController.add(self, name: "clickCartButton")
        userContentController.add(self, name: "clickWishListButton")
        userContentController.add(self, name: "clickCategoryButton")
        userContentController.add(self, name: "clickAccountButton")
        userContentController.add(self, name: "updateCartCount")
        userContentController.add(self, name: "updateWishListCount")
        userContentController.add(self, name: "hideMenuBar")
        userContentController.add(self, name: "logout")
        configuration.userContentController = userContentController
        configuration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        self.view.addSubview(baseWebView)
        baseWebView.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        self.webView.navigationDelegate = self
        self.webView = webView
        baseWebView.addSubview(webView)
        self.webView.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview()
        }
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            if let keyCheck = key as? URL {
                if keyCheck.absoluteString.contains("/products/") {
                    self.hideTabBar()
                } else {
                    self.showTabBar()
                }
            }
        }
    }
    
    func navigateToView(type: BaseViewModel.ActionType) {
        self.actionType = type
        guard actionType != nil else { return }
        switch actionType {
            case .clickHomeButton:
                viewModel.navigateToHome()
                
            case .clickCartButton:
                viewModel.navigateToCart()
                
            case .clickWishListButton:
                viewModel.navigateToWishList()
                
            case .clickCategoryButton:
                viewModel.navigateToCategory()
                
            case .clickAccountButton:
                viewModel.navigateToAccount()
                
            case .none:
                break
        }
    }
    @objc private func hideTabBar() {
        self.tabBarController?.hideTabBar(isHidden: false)
    }
    
    @objc private func showTabBar() {
        self.tabBarController?.hideTabBar(isHidden: true)
    }
    

    
}
extension BaseViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "receiveTokenLogin", let messageBody = message.body as? String {
            print("Received message from JavaScript: \(messageBody)")
            UserDefaults.standard.set(messageBody, forKey: "userLoginToken")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchBadgeData"), object: nil)
        } else if message.name == "clickLoginButton", let messageBody = message.body as? String {
            if messageBody == BaseViewModel.LoginType.Google.rawValue {
                self.signInWithGoogle()
            } else if messageBody == BaseViewModel.LoginType.Apple.rawValue {
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
        } else if message.name == "logout" {
            UserDefaults.standard.removeObject(forKey: "userLoginToken")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearBadgeData"), object: nil)
        } else if message.name == "updateCartCount" || message.name == "updateWishListCount" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchBadgeData"), object: nil)
        } else if message.name == "hideMenuBar" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideTabbar"), object: nil)
        } else if message.name == "showManuBar" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showTabbar"), object: nil)
        }
    }
}
// MARK: - Sign In
extension BaseViewController {
    @objc private func signInWithGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            if let googleUser = GIDSignIn.sharedInstance.currentUser {
                let idToken = googleUser.idToken
                let accessToken = googleUser.accessToken
                let email = googleUser.profile?.email
                self.sentLoginToWeb(loginType: .Google, email: email)
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
    
    private func sentLoginToWeb(loginType: BaseViewModel.LoginType, email: String?) {
        let script = "receiveEmailForLogin('\(loginType)', '\(email ?? "")');"
        webView.evaluateJavaScript(script) { _, error in
            if let error = error {
                print("JavaScript evaluation error: \(error.localizedDescription)")
            }
        }
    }
}
extension BaseViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed login \(error)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            case let credentials as ASAuthorizationAppleIDCredential:
                let email = credentials.email
                self.sentLoginToWeb(loginType: .Apple, email: email)
                break
                
            default:
                break
                
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
   
}
