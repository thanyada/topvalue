//
//  MainViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit

class MainViewController: UITabBarController {

    @IBOutlet weak var mainTabbar: UITabBar!
    private let HEIGHT_TAB_BAR: CGFloat = 112
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBase()
        setupTิabbarTitle()
        setTabbarImage()
        setFont()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = HEIGHT_TAB_BAR
        tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
        self.mainTabbar.frame = tabFrame
        
        self.addBadge(index: 3, value: "10+", color: UIColor.Reds.NormalRedV1, font: R.font.sukhumvitSetBold(size: 12.0)!)
    }
    
    func itemWidthForTabBar(_ tabBar: UITabBar) -> CGFloat {
        return tabBar.frame.width / CGFloat(tabBar.items?.count ?? 1)
    }

    private func setupBase() {
        mainTabbar.backgroundColor = .white
        mainTabbar.tintAdjustmentMode = .normal
        mainTabbar.itemPositioning = .centered
    }
    
    private func setupTิabbarTitle() {
        mainTabbar.items?[0].title = R.string.localizable.category_TABBAR_TITLE()
        mainTabbar.items?[1].title =  R.string.localizable.category_TABBAR_TITLE()
        mainTabbar.items?[2].title = R.string.localizable.wishlist_TABBAR_TITLE()
        mainTabbar.items?[3].title = R.string.localizable.cart_TABBAR_TITLE()
        mainTabbar.items?[4].title = R.string.localizable.account_TABBAR_TITLE()
    }
    
    private func setTabbarImage() {
        mainTabbar.items?[0].image = R.image.icHomeTabbarNormal()
        mainTabbar.items?[1].image = R.image.icCartgoryTabbarNormol()
        mainTabbar.items?[2].image = R.image.icWishlistTabbarNormol()
        mainTabbar.items?[3].image = R.image.icCartTabbarNormol()
        mainTabbar.items?[4].image = R.image.icAccountTabbarNormol()
        mainTabbar.items?[0].selectedImage = R.image.icHomeTabbarSelected()
        mainTabbar.items?[1].selectedImage = R.image.icCartgoryTabbarSelected()
        mainTabbar.items?[2].selectedImage = R.image.icWishlistTabbarSelected()
        mainTabbar.items?[3].selectedImage = R.image.icCartTabbarSelected()
        mainTabbar.items?[4].selectedImage = R.image.icAccountTabbarSelected()
    }
    
    
    private func setFont() {
        guard let items = mainTabbar.items, let normalFont = R.font.sukhumvitSetBold(size: 14.0) , let selectedFont = R.font.sukhumvitSetBold(size: 14.0) else { return }
        for item in items  {
            item.setTitleTextAttributes([NSAttributedString.Key.font: normalFont, NSAttributedString.Key.foregroundColor: UIColor.Grays.NormalGrayV1], for: .normal)
            item.setTitleTextAttributes([NSAttributedString.Key.font: selectedFont, NSAttributedString.Key.foregroundColor: UIColor.Blacks.NormalBlackV1], for: .selected)
        }
//        mainTabbar.items?[3].badgeValue = "0"
       
    }
    
    
}
extension UITabBarController {
    
    func setBadges(badgeValues: [Int]) {

        var labelExistsForIndex = [Bool]()

        for _ in badgeValues {
            labelExistsForIndex.append(false)
        }

        for view in self.tabBar.subviews where view is PGTabBadge {
            let badgeView = view as! PGTabBadge
            let index = badgeView.tag
            
            if badgeValues[index] == 0 {
                badgeView.removeFromSuperview()
            }
            
            labelExistsForIndex[index] = true
            badgeView.text = String(badgeValues[index])
        }

        for i in 0...(labelExistsForIndex.count - 1) where !labelExistsForIndex[i] && (badgeValues[i] > 0) {
            addBadge(index: i, value: "\(badgeValues[i])", color: .red, font: UIFont(name: "Helvetica-Light", size: 11)!)
        }

    }

    func addBadge(index: Int, value: String, color: UIColor, font: UIFont) {
        let itemPosition = CGFloat(index + 1)
        let itemWidth: CGFloat = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let bgColor = color
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = 0
        let badgeView = PGTabBadge()
        badgeView.frame.size =  CGSize(width: 26, height: 16)
        badgeView.center = CGPoint(x: (itemWidth * itemPosition) - (itemWidth / 2) + xOffset, y: 20 + yOffset)
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
    
class PGTabBadge: UILabel { }
