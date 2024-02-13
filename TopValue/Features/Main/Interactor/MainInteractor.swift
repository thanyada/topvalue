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
    var viewModel: MainViewModel?
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    func fetchBadgeCartModel() -> Disposable  {
        let apiURL = "https://api.topvalue.asia/rest/V1/carts/mine/totals?fields=items_qty"//(BaseTools.getApiConfig(key: "host") ?? "") + "/carts/mine/totals?fields=items_qty"
        let userLoginToken = UserDefaults.standard.string(forKey: "userLoginToken")
        viewModel?.isCallingApiEnd.accept(false)
        return serviceManager.request(apiURL, method: .get, headers: ["Authorization": "Bearer \(userLoginToken ?? "")"])
            .subscribe(onNext: { (badgeCartModel: BadgeCartModel) in
                print("BadgeCartModel: \(badgeCartModel.badgeCartCouting)")
                self.viewModel?.isCallingApiEnd.accept(true)
                self.viewModel?.badgeCartModel.accept(badgeCartModel)
            }, onError: { error in
                self.viewModel?.isCallingApiEnd.accept(true)
                print("Error: \(error)")
            })
    }

    func fetchBadgeWishlistModel() -> Disposable {
        let apiURL = "https://api.topvalue.asia/rest/V1/wishlist?fields=total_count" //(BaseTools.getApiConfig(key: "host") ?? "") + "/wishlist?fields=total_count"
        viewModel?.isCallingApiEnd.accept(false)
        let userLoginToken = UserDefaults.standard.string(forKey: "userLoginToken")
        return serviceManager.request(apiURL, method: .get, headers: ["Authorization": "Bearer \(userLoginToken ?? "")"])
            .subscribe(onNext: { (badgeWishlistModel: BadgeWishlistModel) in
                self.viewModel?.isCallingApiEnd.accept(true)
                self.viewModel?.badgeWishlistModel.accept(badgeWishlistModel)
            }, onError: { error in
                self.viewModel?.isCallingApiEnd.accept(true)
                print("Error: \(error)")
            })
    }
    
   
}
