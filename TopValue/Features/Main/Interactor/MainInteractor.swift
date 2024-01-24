//
//  MainInteractor.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import Foundation
import RxRelay
import RxSwift
final class MainInteractor {
    let serviceManager = RxServiceManager.shared
    weak var viewModel: MainViewModel?
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    func fetchBadgeCartModel() -> Disposable  {
        let apiURL = (BaseTools.getApiConfig(key: "host") ?? "") + "/wishlist"
//        let apiURL = "api.topvalue.asia/rest/V1/carts/mine/totals?fields=items_qty"
        let userLoginToken = UserDefaults.standard.string(forKey: "userLoginToken")
        viewModel?.isCallingApiEnd.accept(false)
        return serviceManager.request(apiURL, method: .get, headers: ["Authorization": userLoginToken ?? ""])
            .subscribe(onNext: { (badgeCartModel: BadgeCartModel) in
                print("BadgeCartModel: \(badgeCartModel.badgeCartCouting)")
                self.viewModel?.isCallingApiEnd.accept(true)
                self.viewModel?.badgeCartModel.accept(badgeCartModel)
            }, onError: { error in
                self.viewModel?.isCallingApiEnd.accept(true)
                self.viewModel?.errorSubject.onNext(error)
                print("Error: \(error)")
            })
    }
    
    func fetchBadgeWishlistModel() -> Disposable {
        let apiURL = (BaseTools.getApiConfig(key: "host") ?? "") + "/carts/mine/totals?fields=total_segments"
//        let apiURL = "api.topvalue.asia/rest/V1/wishlist?fields=total_count"
        viewModel?.isCallingApiEnd.accept(false)
        let userLoginToken = UserDefaults.standard.string(forKey: "userLoginToken")
        return serviceManager.request(apiURL, method: .get, headers: ["Authorization": userLoginToken ?? ""])
            .subscribe(onNext: { (badgeWishlistModel: BadgeWishlistModel) in
                print("BadgeCartModel: \(badgeWishlistModel.badgeWishlistCouting)")
                self.viewModel?.isCallingApiEnd.accept(true)
                self.viewModel?.BadgeWishlistModel.accept(badgeWishlistModel)
            }, onError: { error in
                self.viewModel?.isCallingApiEnd.accept(true)
                self.viewModel?.errorSubject.onNext(error)
                print("Error: \(error)")
            })
    }
}
