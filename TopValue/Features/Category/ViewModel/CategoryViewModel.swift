//
//  CategoryViewModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 22/1/2567 BE.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay
struct CategoryViewModel {
    let errorSubject = PublishSubject<Error>()
    var currentIndex = BehaviorRelay<Int>(value: 1)
}
