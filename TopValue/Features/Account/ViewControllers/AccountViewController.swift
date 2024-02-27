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

class AccountViewController: BaseViewController {
    
    @IBOutlet private weak var webContainner: UIView!
    var path: String = ApplicationFlag.accountPath
    private let accountViewModel = AccountViewModel()
    private var lastCurrentIndex: Int = 4
    
    enum LoginType : String {
        case Google = "google"
        case Apple = "apple"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config(request: path)
        createBinding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateRedBar"), object: nil)
    }
    
    private func config(request: String) {
        webView.isOpaque = false
        webView.scrollView.bounces = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = true
        guard let url = URL(string: request) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
        webView.load(request)
//        guard let token = UserDefaults.standard.string(forKey: "userLoginToken") else { return }
//        self.sentAutoLoginToWeb(token: token)
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
    
   
}


