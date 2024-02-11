//
//  BaseViewModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 13/1/2567 BE.
//

import Foundation
class BaseViewModel {
//    struct ActionType {
//        static let clickHomeButton = "clickHomeButton"
//        static let clickCartButton = "clickCartButton"
//        static let clickWishListButton = "clickWishListButton"
//        static let clickCategoryButton = "clickCategoryButton"
//        static let clickAccountButton = "clickAccountButton"
//    }
    enum ActionType: String {
        case clickHomeButton = "clickHomeButton"
        case clickCartButton = "clickCartButton"
        case clickWishListButton = "clickWishListButton"
        case clickCategoryButton = "clickCategoryButton"
        case clickAccountButton = "clickAccountButton"
    }
    enum LoginType : String {
        case Google = "google"
        case Apple = "apple"
    }
    
    func navigateToHome() {
        BaseRouter.shared.gotoHomeViewController()
    }
    
    func navigateToCart() {
        BaseRouter.shared.gotoCartViewController()
    }
    
    func navigateToCategory() {
        BaseRouter.shared.gotoCategoryViewController()
    }
    
    func navigateToAccount() {
        BaseRouter.shared.gotoAccountViewController()
    }
    
    func navigateToWishList() {
        BaseRouter.shared.gotoWishListViewController()
    }
}
