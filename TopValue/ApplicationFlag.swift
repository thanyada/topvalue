//
//  ApplicationFlag.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 14/1/2567 BE.
//

import Foundation
struct ApplicationFlag {
    private init() {}

//    #if DEBUG
    static let accountPath = "https://topvalue.asia/customer/account"
    static let cartPath = "https://topvalue.asia/customer/cart/products"
    static let wishListPath = "https://topvalue.asia/customer/account/wishlist"
    static let categoryPath = "https://topvalue.asia/m/categories"
    static let homePagePath = "https://topvalue.asia/"
   
//    #else
//    static let accountPath = "https://topvalue.com/customer/account"
//    static let cartPath = "https://topvalue.com/customer/cart/products"
//    static let wishListPath = "https://topvalue.com/customer/account/wishlist"
//    static let categoryPath = "https://topvalue.com/m/categories"
//    static let homePagePath = "https://topvalue.com/"
//    #endif
}
