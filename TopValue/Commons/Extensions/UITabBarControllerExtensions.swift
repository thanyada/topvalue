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
        if let existingBadgeView = tabBar.viewWithTag(index) as? PGTabBadge {
            existingBadgeView.text = "\(value)"
            existingBadgeView.isHidden = false
            existingBadgeView.layoutIfNeeded()
        } else {
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
    }
    
    func updateBadgeText(index: Int, newValue: Int) {
        if let badgeView = tabBar.viewWithTag(index) as? PGTabBadge {
            badgeView.isHidden = newValue == 0
            badgeView.text = "\(newValue)"
            badgeView.layoutIfNeeded()
        }
    }
    
    func hiddenBadge(index: Int) {
        if let badgeView = tabBar.viewWithTag(index) as? PGTabBadge {
            badgeView.text = ""
            badgeView.isHidden = true
            badgeView.layoutIfNeeded()
        }
    }
    func removeBadge(index: Int) {
        if let badgeView = tabBar.viewWithTag(index) as? PGTabBadge {
            badgeView.removeFromSuperview()
        }
    }
    
    func hideTabBar(isHidden:Bool) {
        if (isTabBarAlreadyHidden() == isHidden) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (isHidden ? -height : height)
        self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
        self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
    }
    
    func isTabBarAlreadyHidden() -> Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}


