//
//  CartViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import WebKit

class CartViewController: BaseViewController {

    @IBOutlet private weak var webContainner: UIView!
    var path: String = ApplicationFlag.cartPath
    private let cartViewModel = CartViewModel()
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
        
        cartViewModel
            .currentIndex
            .subscribe(onNext: { [weak self] currentIndex in
                guard let self = self else { return }
                if currentIndex == 3, self.webView.url?.absoluteString != self.path {
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
            self.cartViewModel.currentIndex.accept(selectedIndex)
        }
    }
}
