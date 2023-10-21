//
//  UITabBarControllerExtensions.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import UIKit
public class PGTabBadge: UILabel { }

extension UITabBarController {
    
//    func setBadges(badgeValues: [Int]) {
//
//        var labelExistsForIndex = [Bool]()
//
//        for _ in badgeValues {
//            labelExistsForIndex.append(false)
//        }
//
//        for view in self.tabBar.subviews where view is PGTabBadge {
//            let badgeView = view as! PGTabBadge
//            let index = badgeView.tag
//
//            if badgeValues[index] == 0 {
//                badgeView.removeFromSuperview()
//            }
//
//            labelExistsForIndex[index] = true
//            badgeView.text = String(badgeValues[index])
//        }
//
//        for i in 0...(labelExistsForIndex.count - 1) where !labelExistsForIndex[i] && (badgeValues[i] > 0) {
//            addBadge(index: i, value: "\(badgeValues[i])", color: .red, font: UIFont(name: "Helvetica-Light", size: 11)!, badgeYPosition: <#CGFloat#>)
//        }
//
//    }

    func addBadge(index: Int, value: String, color: UIColor, font: UIFont, badgeYPosition: CGFloat) {
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
        badgeView.text = value
        badgeView.backgroundColor = bgColor
        badgeView.tag = index
        badgeView.layer.borderWidth = 1
        badgeView.layer.borderColor = UIColor.white.cgColor
        tabBar.addSubview(badgeView)
    }
}
    

