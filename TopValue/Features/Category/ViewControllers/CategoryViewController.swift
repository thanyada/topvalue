//
//  CategoryViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import WebKit

class CategoryViewController: BaseViewController {

    @IBOutlet private weak var webContainner: UIView!
    private var path: String = ApplicationFlag.categoryPath
    
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
    }
    
    private func createBinding() {
        webView.rx.navigationAction
            .subscribe(onNext: { action in
                switch action {
                    case let .navigationAction(webView, action, handler):
                        print("navigationAction. action = \(action)")
                        print("navigationAction. target = \(webView.url?.absoluteString ?? "<nil>")")
                        handler(WKNavigationActionPolicy.allow)
                    case let .didStart(webView, navigation):
                        print("start web page. action = \(navigation)")
                        print("start web page. target = \(webView.url?.absoluteString ?? "<nil>")")
                    case let .didFinish(webView, navigation):
                        print("end web page. action = \(navigation)")
                        print("end web page. target = \(webView.url?.absoluteString ?? "<nil>")")
                }
            })
            .disposed(by: disposeBag)
    }
    
   

}
