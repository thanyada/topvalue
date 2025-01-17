//
//  AccountViewModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 13/1/2567 BE.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay
struct AccountViewModel {
    let errorSubject = PublishSubject<Error>()
    var currentIndex = BehaviorRelay<Int>(value: 4)
}
