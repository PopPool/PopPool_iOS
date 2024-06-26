//
//  Provider.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation
import RxSwift
import RxAlamofire

protocol Provider {
    /// 네트워크 요청을 수행하고 결과를 반환하는 메서드
    /// - Parameter endpoint: 요청 엔드포인트
    /// - Returns: 요청에 대한 결과를 Observable로 반환
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E) -> Observable<R> where R == E.Response
}

class ProviderImpl: Provider {
    
    let disposeBag = DisposeBag()
    
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E) -> Observable<R> where R == E.Response {
        
        return Observable.create {[weak self] observer in
            
            guard let self = self else { 
                return Disposables.create()
            }
            
            do {
                var urlRequest = try endpoint.getUrlRequest()
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                RxAlamofire.requestData(urlRequest)
                    .flatMap { (response, data) -> Observable<Data> in
                        return self.checkError(with: data, response)
                    }
                    .flatMap { data -> Observable<R> in
                        return self.decodeData(data: data)
                    }
                    .subscribe { decodeData in
                        observer.onNext(decodeData)
                        observer.onCompleted()
                    } onError: { error in
                        observer.onError(error)
                    }.disposed(by: self.disposeBag)
            } catch {
                observer.onError(NetworkError.urlRequest(error))
            }
            return Disposables.create()
        }
    }
    
    /// HTTP 응답 상태 코드 확인 및 처리
    /// - Parameters:
    ///   - data: 응답 데이터
    ///   - response: HTTP 응답
    /// - Returns: 응답 데이터를 Observable로 반환
    private func checkError(with data: Data, _ response: HTTPURLResponse) -> Observable<Data> {
        return Observable.create { observer in
            if (200...299).contains(response.statusCode) {
                observer.onNext(data)
                observer.onCompleted()
            } else {
                observer.onError(NetworkError.invalidHttpStatusCode(response.statusCode))
            }
            return Disposables.create()
        }
    }
    
    /// JSON 데이터 디코딩 처리
    /// - Parameter data: 디코딩할 데이터
    /// - Returns: 디코딩된 데이터를 Observable로 반환
    private func decodeData<R: Decodable>(data: Data) -> Observable<R> {
        return Observable.create { observer in
            do {
                let decodeData = try JSONDecoder().decode(R.self, from: data)
                observer.onNext(decodeData)
                observer.onCompleted()
            } catch {
                observer.onError(NetworkError.decodeError)
            }
            return Disposables.create()
        }
    }
}
