//
//  RxServiceManager.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

class RxServiceManager {

    static let shared = RxServiceManager()

    private let sessionManager: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        self.sessionManager = Session(configuration: configuration)
    }

    func request<T: Mappable>(_ url: URLConvertible,
                                  method: HTTPMethod = .get,
                                  parameters: Parameters? = nil,
                                  encoding: ParameterEncoding = URLEncoding.default,
                                  headers: HTTPHeaders? = nil) -> Observable<T> {

            return Observable.create { observer in
                let request = self.sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                    .validate()
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                            if let parsedObject = Mapper<T>().map(JSONString: String(data: data, encoding: .utf8) ?? "") {
                                observer.onNext(parsedObject)
                                observer.onCompleted()
                            } else {
                                let error = NSError(domain: "MappingError", code: 0, userInfo: nil)
                                observer.onError(error)
                            }
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }

                // Store the request and observer for later cancellation
                let disposable = Disposables.create {
                    request.cancel()
                }
                return disposable
            }
        }
}
