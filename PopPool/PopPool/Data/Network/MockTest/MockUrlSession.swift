//
//  MockUrlSession.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation
import RxSwift

/// 테스트를 위한 URLSession입니다
/// XCTest에서 활용합니다
class MockUrlSession: URLSessionable {
    
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?
    
    /// URLSession으로 서버에 데이터 요청을 보내고 응답을 받을 때 사용하는 메서드입니다
    /// URLRequest로 데이터를 처리하는 메서드입니다
    /// - Parameter request: URLRequest
    /// - Returns: Observable Data
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
    
    /// URLSession으로 서버에 데이터 요청을 보내고 응답을 받을 때 사용하는 메서드입니다
    /// URL만으로 데이터를 처리하는 메서드입니다
    /// - Parameter request: URL
    /// - Returns: Observable Data
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
