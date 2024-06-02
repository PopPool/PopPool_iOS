//
//  URLSessionable.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation
import RxSwift

/// URLSession 테스트를 위한 프로토콜입니다
protocol URLSessionable {
    func dataTask(with request: URLRequest) -> Observable<(response: URLResponse, data: Data)>
    func dataTask(with url: URL) -> Observable<(response: URLResponse, data: Data)>
}

extension URLSession: URLSessionable {
    
    /// URLSession으로 서버에 데이터 요청을 보내고 응답을 받을 때 사용하는 메서드입니다
    /// URLRequest로 데이터를 처리하는 메서드입니다
    /// - Parameter request: URLRequest
    /// - Returns: Observable Data
    func dataTask(with request: URLRequest) -> Observable<(response: URLResponse, data: Data)> {
        return Observable.create { observer in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data, let response = response {
                    observer.onNext((response: response, data: data))
                    observer.onCompleted()
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// URLSession으로 서버에 데이터 요청을 보내고 응답을 받을 때 사용하는 메서드입니다
    /// URL만으로 데이터를 처리하는 메서드입니다
    /// - Parameter request: URL
    /// - Returns: Observable Data
    func dataTask(with url: URL) -> Observable<(response: URLResponse, data: Data)> {
        return Observable.create { observer in
            let task = self.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data, let response = response {
                    observer.onNext((response: response, data: data))
                    observer.onCompleted()
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
