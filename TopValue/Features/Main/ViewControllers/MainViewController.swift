//
//  MainViewController.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import RxCocoa
import RxSwift
class MainViewController: UITabBarController, UITabBarControllerDelegate {

    @IBOutlet weak var mainTabbar: CustomTabBar!
    private var interactor: MainInteractor?
    private var viewModel: MainViewModel = MainViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private struct Constants {
        static let heightTapBar: CGFloat = BaseTools.getTabbarSaveArea(condition1: 112, condition2: 68)
        static let badgeYPosition: CGFloat = BaseTools.getTabbarSaveArea(condition1: 20, condition2: 15)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = MainViewModel()
        interactor = MainInteractor(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupBase()
        setupTิabbarTitle()
        setTabbarImage()
        setFont()
        bind(viewModel, disposeBag)
        fetchBadgeCartCouting()
        fetchBadgeWishListCouting()
        setupBinding()
        setupNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchCartData), name: NSNotification.Name(rawValue: "fetchBadgeData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeAllBadgeData), name: NSNotification.Name(rawValue: "clearBadgeData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRedBar), name: NSNotification.Name(rawValue: "updateRedBar"), object: nil)
    }
    
    func itemWidthForTabBar(_ tabBar: UITabBar) -> CGFloat {
        return tabBar.frame.width / CGFloat(tabBar.items?.count ?? 1)
    }
    
    
    private func setupBinding() {
        viewModel
            .badgeCartModel
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] model in
                guard let self = self, let badgeCardCount = model?.badgeCartCouting, badgeCardCount > 0 else {
                    self?.removeBadge(index: 3)
                    return
                }
                self.addBadge(
                    index: 3,
                    value: badgeCardCount,
                    color: UIColor.Reds.NormalRedV1,
                    font: R.font.sukhumvitSetBold(size: 12.0)!,
                    badgeYPosition: Constants.badgeYPosition
                )
            })
            .disposed(by: self.disposeBag)
        
        viewModel
            .badgeWishlistModel
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] model in
                guard let self = self, let badgeWishlistCount = model?.badgeWishlistCount, badgeWishlistCount > 0 else {
                    self?.removeBadge(index: 2)
                    return
                }
                self.addBadge(index: 2,
                              value: badgeWishlistCount,
                              color: UIColor.Reds.NormalRedV1,
                              font: R.font.sukhumvitSetBold(size: 12.0)!,
                              badgeYPosition: Constants.badgeYPosition
                )
            })
            .disposed(by: self.disposeBag)
        
    }
    
    private func setupBase() {
        CustomTabBar.appearance().shadowImage = UIImage()
        CustomTabBar.appearance().backgroundImage = UIImage()
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
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            let userInfo: [String: Any] = ["selectedIndex": index]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarDidSelected"), object: nil, userInfo: userInfo)
            updateRedBar()
        }
    }
    
    @objc private func fetchCartData() {
        self.removeBadge(index: 2)
        self.removeBadge(index: 3)
        fetchBadgeCartCouting()
        fetchBadgeWishListCouting()
    }
    
    @objc private func removeAllBadgeData() {
        fetchCartData()
    }
    
    @objc private func updateRedBar() {
        self.mainTabbar.updateSelectedView()
    }
}

// MARK - service request
extension MainViewController {
    private func fetchBadgeCartCouting() {
        interactor?.fetchBadgeCartModel()
            .disposed(by: self.disposeBag)
    }
    
    private func fetchBadgeWishListCouting() {
        interactor?.fetchBadgeWishlistModel()
            .disposed(by: self.disposeBag)
    }
   
}

