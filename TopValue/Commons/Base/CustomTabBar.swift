//
//  CustomTabBar.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 14/1/2567 BE.
//

import UIKit
class CustomTabBar: UITabBar {
    private var borderView: UIView?
    override func layoutSubviews() {
        super.layoutSubviews()
        borderView?.removeFromSuperview()
        if let selectedItem = selectedItem,
           let index = items?.firstIndex(of: selectedItem) {
            let borderColor = UIColor.red
            let borderWidth: CGFloat = 2.0
            let newBorderView = UIView()
            newBorderView.backgroundColor = borderColor
            newBorderView.frame = CGRect(x: 0, y: 0, width: frame.width / CGFloat(items?.count ?? 1), height: borderWidth)
            newBorderView.frame.origin.x = CGFloat(index) * (frame.width / CGFloat(items?.count ?? 1))
            addSubview(newBorderView)
            borderView = newBorderView
        }
    }
}
