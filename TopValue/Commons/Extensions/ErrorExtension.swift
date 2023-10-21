//
//  ErrorExtension.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import UIKit
public enum TopValueError: LocalizedError {
    case loginError(message: String)
    case serviceError(message: String)
    
    public var errorDescription: String? {
        switch self {
            case .loginError(let message):
                return "login failed \(message)"
            
            case .serviceError(let message):
                return "service Error \(message)"
                
        }
    }
}

public extension Error {
    private var _message: String {
        return self.localizedDescription
    }
    
    func alert(on: UIViewController, done: (() -> Void)? = nil) {
        UIAlertController.inform(title: nil, message: self._message, on: on, done: done)
    }

}
