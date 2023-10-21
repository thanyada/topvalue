//
//  UIAlertControllerExtension.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import UIKit
public extension UIAlertController {
    enum BasicAction {
        case cancel(title: String?), ok, confirm(title: String?), retry
        
        func `do`(callback: @escaping () -> Void) -> UIAlertAction {
            switch self {
                case .cancel(let title):
                    let text = title != nil ? title : "cancle"
                    return UIAlertAction(title: text, style: .cancel) { _ in
                        callback()
                    }
                    
                case .confirm(let title):
                    let text = title != nil ? title : "confirm"
                    return UIAlertAction(title: text, style: .default) { _ in
                        callback()
                    }
                    
                case .ok:
                    return UIAlertAction(title: "ok", style: .default) { _ in
                        callback()
                    }
                    
                case .retry:
                    return UIAlertAction(title: "retry", style: .default, handler: { _ in
                        callback()
                    })
            }
        }
    }
    
    static func inform(title: String? = nil, message: String, on: UIViewController, done: (() -> Void)? = nil) {
        let ctrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ctrl.addAction(BasicAction.ok.do {
            done?()
        })
        ctrl.view.tintColor = UIColor.red
        on.present(ctrl, animated: true, completion: nil)
    }
}
