//
//  Provider.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol Provider {
    /// 네트워크 요청을 수행하고 결과를 반환하는 메서드
    /// - Parameter endpoint: 요청 엔드포인트
    /// - Parameter interceptor: RequestInterceptor
    /// - Returns: 요청에 대한 결과를 Observable로 반환
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E, interceptor: RequestInterceptor) -> Observable<R> where R == E.Response
    
    /// 네트워크 요청을 수행하고 결과를 반환하는 메서드
    /// - Parameter endpoint: 요청 엔드포인트
    /// - Returns: 요청에 대한 결과를 Observable로 반환
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E) -> Observable<R> where R == E.Response
    
    /// 네트워크 요청을 수행하고 결과를 반환하는 메서드
    /// - Parameter request: 요청 엔드포인트
    /// - Parameter interceptor: RequestInterceptor
    /// - Returns: 요청에 대한 결과를 반환
    func request<E: Requestable>(with request: E, interceptor: RequestInterceptor) -> Completable
}

class ProviderImpl: Provider {
    
    let disposeBag = DisposeBag()
    
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E, interceptor: RequestInterceptor) -> Observable<R> where R == E.Response {
        
        return Observable.create { observer in
            
            do {
                let urlRequest = try endpoint.getUrlRequest()
                AF.request(urlRequest, interceptor: interceptor)
                    .validate()
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                            do {
                                let decodeData = try JSONDecoder().decode(R.self, from: data)
                                observer.onNext(decodeData)
                            } catch {
                                observer.onError(NetworkError.decodeError)
                            }
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
            } catch {
                observer.onError(NetworkError.urlRequest(error))
            }
            return Disposables.create()
        }
    }
    
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E) -> Observable<R> where R == E.Response {
        
        return Observable.create { observer in
            
            do {
                var urlRequest = try endpoint.getUrlRequest()
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                AF.request(urlRequest)
                    .validate()
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                            do {
                                let decodeData = try JSONDecoder().decode(R.self, from: data)
                                observer.onNext(decodeData)
                            } catch {
                                print("DecodeError")
                                observer.onError(NetworkError.decodeError)
                            }
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
            } catch {
                observer.onError(NetworkError.urlRequest(error))
            }
            return Disposables.create()
        }
    }
    
    func request<E: Requestable>(with request: E, interceptor: RequestInterceptor) -> Completable {

        return Completable.create { observer in
            
            do {
                let urlRequest = try request.getUrlRequest()
                AF.request(urlRequest, interceptor: interceptor)
                    .validate()
                    .response { response in
                        switch response.result {
                        case .success:
                            observer(.completed)
                        case .failure(let error):
                            if let data = response.data {
                                if let errorMessage = String(data: data, encoding: .utf8) {
                                    print(errorMessage)
                                    observer(.error(NetworkError.serverError(errorMessage)))
                                }
                            } else {
                                observer(.error(error))
                            }
                        }
                    }
            } catch {
                observer(.error(NetworkError.urlRequest(error)))
            }
            return Disposables.create()
        }
    }
}
