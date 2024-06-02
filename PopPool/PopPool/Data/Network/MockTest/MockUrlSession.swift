//
//  MockUrlSession.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation
import RxSwift

class MockUrlSession: URLSessionable {
    
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?
    
    func dataTask(with request: URLRequest) -> Observable<(response: URLResponse, data: Data)> {
        return Observable.create { observer in
            if let error = self.nextError {
                observer.onError(error)
            } else if let data = self.nextData, let response = self.nextResponse {
                observer.onNext((response: response, data: data))
                observer.onCompleted()
            } else {
                observer.onError(NetworkError.unknownError)
            }
            return Disposables.create()
        }
    }
    
    func dataTask(with url: URL) -> Observable<(response: URLResponse, data: Data)> {
        return Observable.create { observer in
            if let error = self.nextError {
                observer.onError(error)
            } else if let data = self.nextData, let response = self.nextResponse {
                observer.onNext((response: response, data: data))
                observer.onCompleted()
            } else {
                observer.onError(NetworkError.unknownError)
            }
            return Disposables.create()
        }
    }
}
