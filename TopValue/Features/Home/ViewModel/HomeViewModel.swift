//
//  HomeViewModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 17/1/2567 BE.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay

struct HomeViewModel: RxViewModelProtocol {
    let errorSubject = PublishSubject<Error>()
    var currentIndex = BehaviorRelay<Int>(value: 0)
}
