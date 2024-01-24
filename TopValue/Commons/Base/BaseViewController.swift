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

class BaseViewController: UIViewController {
    
//    var webView: WKWebView {
//        let configuration = WKWebViewConfiguration()
//        configuration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
//        let webView = WKWebView(frame: view.bounds, configuration: configuration)
//        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        return webView
//    }
    
    var disposeBag: DisposeBag = DisposeBag()
    var viewModel = BaseViewModel()
    var actionType: BaseViewModel.ActionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
//    func config(request: String) {
//        webView.isOpaque = false
//        webView.scrollView.bounces = false
//        webView.scrollView.showsHorizontalScrollIndicator = false
//        webView.scrollView.showsVerticalScrollIndicator = true
//        guard let url = URL(string: request) else { return }
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
    
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

}
