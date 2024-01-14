//
//  BaseRouter.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 13/1/2567 BE.
//

import UIKit
class BaseRouter {
    static let shared = BaseRouter()
    func gotoHomeViewController() {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
    }
    
    func gotoCategoryViewController() {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    func gotoWishListViewController() {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 2
        }
    }
    
    func gotoCartViewController() {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 3
        }
    }
    
    func gotoAccountViewController() {
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 4
        }
    }
    
   
}
