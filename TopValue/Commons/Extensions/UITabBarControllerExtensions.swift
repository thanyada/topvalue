//
//  UITabBarControllerExtensions.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import UIKit
public class PGTabBadge: UILabel { }

extension UITabBarController {
    
    func addBadge(index: Int, value: Int, color: UIColor, font: UIFont, badgeYPosition: CGFloat) {
        let itemPosition = CGFloat(index + 1)
        let itemWidth: CGFloat = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let bgColor = color
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = 0
        let badgeView = PGTabBadge()
        badgeView.frame.size =  CGSize(width: 26, height: 16)
        badgeView.center = CGPoint(x: (itemWidth * itemPosition) - (itemWidth / 2) + xOffset, y: badgeYPosition + yOffset)
        badgeView.layer.cornerRadius = 6.0
        badgeView.clipsToBounds = true
        badgeView.textColor = UIColor.white
        badgeView.textAlignment = .center
        badgeView.font = font
        badgeView.text = "\(value)"
        badgeView.backgroundColor = bgColor
        badgeView.tag = index
        badgeView.layer.borderWidth = 1
        badgeView.layer.borderColor = UIColor.white.cgColor
        tabBar.addSubview(badgeView)
    }
    
    func removeBadge(index: Int) {
        if let badgeView = tabBar.viewWithTag(index) as? PGTabBadge {
            badgeView.removeFromSuperview()
        }
    }
}
    

