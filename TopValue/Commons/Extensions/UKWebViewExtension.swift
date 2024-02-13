//
//  UKWebViewExtension.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 13/2/2567 BE.
//

import Foundation
import WebKit
extension WKWebView {
    func currentURL() -> URL? {
        return self.url
    }
    func reloadWithoutCache() {
        guard let url = self.url else {
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        self.load(request)
    }
}
