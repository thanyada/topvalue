//
//  BundleExtension.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import Foundation

extension Bundle {

    static var appVersionBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String
            else { return "" }
        return version
    }


    static var appBuildBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleVersion"] as? String
            else { return "" }
        return version
    }
}
