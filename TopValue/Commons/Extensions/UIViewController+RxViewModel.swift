//
//  UIViewController+RxViewModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import RxSwift
import UIKit
protocol RxViewModelProtocol {
    var errorSubject: PublishSubject<Error> { get }
}

extension UIViewController {
    func bind(_ rxViewModel: RxViewModelProtocol, _ disposedBy: DisposeBag, errorReported: (() -> Void)? = nil, exitFlow: (() -> Void)? = nil) {
        rxViewModel
            .errorSubject
            .observeOn(MainScheduler.instance)
            .filter { [unowned self] e in
                return self.viewIfLoaded?.window != nil && self.view.window != nil && self._shouldHandleError(error: e)
            }
            .delay(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] o in
                if let err = o as? TopValueError, case .loginError = err {
                    o.alert(on: self, done: exitFlow)
                } else {
                    o.alert(on: self)
                }
                errorReported?()
            })
            .disposed(by: disposedBy)
    }
    
    func _shouldHandleError(error e: Error) -> Bool {
        if let mymoError = e as? TopValueError, case let .serviceError(messageToUser) = mymoError {
            NSLog("Error Subject detected warning error with message=\"\(messageToUser)\" and has been ignored. Warnings must be invoker.")
            return false
        }
        return true
    }
    
}
