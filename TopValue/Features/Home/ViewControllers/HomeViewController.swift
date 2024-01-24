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
    private var webView: WKWebView = WKWebView()
    private var lastCurrentIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        config(request: path)
        createBinding()
    }
    
    private func setupView() {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
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
    
    private func createBinding() {
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(handleTabbarDidSelected),
                name: NSNotification.Name(rawValue: "tabbarDidSelected"),
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
    }
    
}
extension HomeViewController: WKScriptMessageHandler, WKNavigationDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "clickHomeButton" {
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
