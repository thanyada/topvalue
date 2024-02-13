//
//  MainViewModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import Alamofire
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay

class MainViewModel: RxViewModelProtocol {
    let isCallingApiEnd = BehaviorRelay<Bool>(value: true)
    let errorSubject = PublishSubject<Error>()
    var badgeCartModel = BehaviorRelay<BadgeCartModel?>(value: nil)
    var badgeWishlistModel = BehaviorRelay<BadgeWishlistModel?>(value: nil)
    
}
