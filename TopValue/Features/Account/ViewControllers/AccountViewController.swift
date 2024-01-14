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

class AccountViewController: BaseViewController{
    
    @IBOutlet private weak var webContainner: UIView!
    var path: String = ApplicationFlag.accountPath

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
        self.webContainner.addSubview(webView)
        self.webView.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview()
        }
        let loginGoogle = UIButton(frame: .zero)
        loginGoogle.backgroundColor = .blue
        loginGoogle.setTitle("Google", for: .normal)
        loginGoogle.layer.cornerRadius = 10.0
        self.webContainner.addSubview(loginGoogle)
        loginGoogle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        loginGoogle.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        
        
        let loginApple = ASAuthorizationAppleIDButton(frame: .zero)
        loginApple.layer.cornerRadius = 10.0
        self.webContainner.addSubview(loginApple)
        loginApple.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        loginApple.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
    }
    
    
    private func createBinding() {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "receiveTokenLogin")
        userContentController.add(self, name: "clickLoginButton")
    }
    
    @objc private func signInWithGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            if let googleUser = GIDSignIn.sharedInstance.currentUser {
                let idToken = googleUser.idToken
                let accessToken = googleUser.accessToken
                let email = googleUser.profile?.email
                // Use idToken and accessToken as needed
                print("ID Token: \(idToken)")
                print("Access Token: \(accessToken)")
                print("User Profile Email \(email)")
                self.sentLoginWithGoogleToWeb(loginType: .Google, email: email)
            }
        }
    }
    
    @objc private func signInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func sentLoginWithGoogleToWeb(loginType: LoginType, email: String?) {
        // Send the email back to the web page using evaluateJavaScript
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
        } else if message.name == "clickLoginButton", let messageBody = message.body as? String {
            if messageBody == LoginType.Google.rawValue {
                self.signInWithGoogle()
            } else if messageBody == LoginType.Apple.rawValue {
                self.signInWithApple()
            }
        }
    }
}
