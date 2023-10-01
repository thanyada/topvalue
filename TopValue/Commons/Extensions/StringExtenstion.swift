//
//  StringExtenstion.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import Foundation
extension String {
    func localized(tableName: String = "Localized") -> String {
        let localizedString = NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
        return localizedString
    }
}
