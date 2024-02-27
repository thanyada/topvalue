//
//  localModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 23/2/2567 BE.
//

import Foundation
struct LocalModel {
    private init() {}
    static var shared = LocalModel()
    var isAutoLoginSuccess: Bool = false
    mutating func updateAutoLoginState(state: Bool) {
        isAutoLoginSuccess = state
    }
}
