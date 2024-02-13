//
//  HomeViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import WebKit
class HomeViewController: BaseViewController {
    @IBOutlet private weak var webContainner: UIView!
    private var path: String = ApplicationFlag.homePagePath
    private let homeViewModel = HomeViewModel()
    private var lastCurrentIndex: Int = 0
    private var isLogin: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        config(request: path)
        createBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let isLogin else { return }
        if isLogin {
            movetoBasePath()
            self.isLogin = nil
        } else {
            movetoBasePath()
            self.isLogin = nil
        }
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
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(updateLoginSuccess),
                name: NSNotification.Name(rawValue: "loginSuccess"),
                object: nil
            )
        
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(updateLogoutSuccess),
                name: NSNotification.Name(rawValue: "logoutSuccess"),
                object: nil
            )
        
        homeViewModel
            .currentIndex
            .subscribe(onNext: { [weak self] currentIndex in
                guard let self = self else { return }
                if currentIndex == 0, self.lastCurrentIndex == 0, self.webView.url?.absoluteString != self.path {
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
    
    @objc private func updateLoginSuccess() {
        isLogin = true
    }
    
    @objc private func updateLogoutSuccess() {
        isLogin = false
    }
    
    @objc private func handleTabbarDidSelected(_ notification: Notification) {
        if let userInfo = notification.userInfo, let selectedIndex = userInfo["selectedIndex"] as? Int {
            self.homeViewModel.currentIndex.accept(selectedIndex)
        }
    }
    
    func config(request: String) {
        webView.isOpaque = false
        webView.scrollView.bounces = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = true
        guard let url = URL(string: request) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        guard let token = UserDefaults.standard.string(forKey: "userLoginToken") else { return }
        self.sentAutoLoginToWeb(token: token)
    }
    
    private func sentAutoLoginToWeb(token: String) {
        let script = "autoLogin('\(token)');"
        webView.evaluateJavaScript(script) { _, error in
            if let error = error {
                print("JavaScript evaluation error: \(error.localizedDescription)")
            }
        }
    }
}

