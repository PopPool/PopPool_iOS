//
//  URLSessionable.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation
import RxSwift

/// URLSession 테스트를 위한 protocol
protocol URLSessionable {
    func dataTask(with request: URLRequest) -> Observable<(response: URLResponse, data: Data)>
    func dataTask(with url: URL) -> Observable<(response: URLResponse, data: Data)>
}

extension URLSession: URLSessionable {
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
