//
//  BaseTools.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import UIKit
class BaseTools {
    
    class func getApiConfig(key: String) -> String? {
        var api: [String: String] = [:]
        if let apiInConfig = BaseTools.getInfoConfig(key: "api") as? [String: String] {
            api = apiInConfig
        }
        return api[key]
    }
    
    class func getInfoConfig(key: String) -> Any? {
        return Bundle.main.object(forInfoDictionaryKey: key)
    }
    
    class func getTabbarSaveArea(condition1: CGFloat, condition2: CGFloat) -> CGFloat {
        if #available(iOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets {
                if safeAreaInsets.bottom > 0 {
                    return condition1
                } else {
                    return condition2
                }
            }
        }
        return condition1
    }
}
