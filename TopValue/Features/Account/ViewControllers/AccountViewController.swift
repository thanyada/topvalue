//
//  AccountViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import WebKit

class AccountViewController: BaseViewController {

    @IBOutlet private weak var webContainner: UIView!
    var path: String = "https://topvalue.com/customer/account"
    
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
                        if let userAgent = webView.value(forKey: "userAgent") {
                            print("===========")
                            print("=====navigationAction======")
                            print("User Agent: \(userAgent)")
                            print("===========")
                        }
//                        print("navigationAction. action = \(action)")
//                        print("navigationAction. target = \(webView.url?.absoluteString ?? "<nil>")")
                        handler(WKNavigationActionPolicy.allow)
                    case let .didStart(webView, navigation):
//                        print("start web page. action = \(navigation)")
//                        print("start web page. target = \(webView.url?.absoluteString ?? "<nil>")")
                        if let userAgent = webView.value(forKey: "userAgent") {
                            print("=====didStart======")
                            print("User Agent: \(userAgent)")
                            print("===========")
                        }
                    case let .didFinish(webView, navigation):
//                        print("end web page. action = \(navigation)")
//                        print("end web page. target = \(webView.url?.absoluteString ?? "<nil>")")
                        if let userAgent = webView.value(forKey: "userAgent") {
                            print("=====didFinish======")
                            print("User Agent: \(userAgent)")
                            print("===========")
                        }
                }
            })
            .disposed(by: disposeBag)
    }

}
