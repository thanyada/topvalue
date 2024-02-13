//
//  WishlistViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import WebKit

class WishlistViewController: BaseViewController {

    @IBOutlet private weak var webContainner: UIView!
    var path: String = ApplicationFlag.wishListPath
    private let wishlistViewModel = WishlistViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        config(request: path)
        createBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            guard let _ = UserDefaults.standard.string(forKey: "userLoginToken") else {
                self.viewModel.navigateToAccount()
                return
            }
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
        
        wishlistViewModel
            .currentIndex
            .subscribe(onNext: { [weak self] currentIndex in
                guard let self = self else { return }
                if currentIndex == 2, self.webView.url?.absoluteString != self.path {
                    self.movetoBasePath()
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func movetoBasePath() {
        guard let url = URL(string: path) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func handleTabbarDidSelected(_ notification: Notification) {
        if let userInfo = notification.userInfo, let selectedIndex = userInfo["selectedIndex"] as? Int {
            self.wishlistViewModel.currentIndex.accept(selectedIndex)
            self.showTabBar()
        }
    }
}
//extension WishlistViewController: WKScriptMessageHandler, WKNavigationDelegate {
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        if message.name == "clickHomeButton" {
//            viewModel.navigateToHome()
//        } else if message.name == "clickCartButton" {
//            viewModel.navigateToCart()
//        } else if message.name == "clickWishListButton" {
//            viewModel.navigateToWishList()
//        } else if message.name == "clickCategoryButton" {
//            viewModel.navigateToCategory()
//        } else if message.name == "clickAccountButton" {
//            viewModel.navigateToAccount()
//        } else if message.name == "updateCartCount" || message.name == "updateWishListCount" {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchBadgeData"), object: nil)
//        } else if message.name == "hideMenuBar" {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideTabbar"), object: nil)
//        } else if message.name == "showManuBar" {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showTabbar"), object: nil)
//        }
//    }
//}
//
