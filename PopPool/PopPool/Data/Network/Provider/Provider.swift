//
//  Provider.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation
import RxSwift

protocol Provider {
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E) -> Observable<R>
}

class ProviderImpl: Provider {
    
    let session: URLSessionable
    let disposeBag = DisposeBag()
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func requestData<R, E>(with endpoint: E) -> Observable<R> where R: Decodable, E: RequesteResponsable {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            
            do {
                let urlRequest = try endpoint.getUrlRequest()
                
                self.session.dataTask(with: urlRequest)
                    .flatMap { (response, data) -> Observable<Result<Data, Error>> in
                        return self.checkError(with: data, response, nil)
                    }
                    .subscribe(onNext: { result in
                        switch result {
                        case .success(let validData):
                            do {
                                let decodedData = try JSONDecoder().decode(R.self, from: validData)
                                observer.onNext(decodedData)
                                observer.onCompleted()
                            } catch {
                                observer.onError(error)
                            }
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }, onError: { error in
                        observer.onError(error)
                    })
                    .disposed(by: self.disposeBag)
                
            } catch {
                observer.onError(NetworkError.unknownError)
            }
            
            return Disposables.create()
        }
    }
    
    // Private
    private func checkError(with data: Data?, _ response: URLResponse?, _ error: Error?) -> Observable<Result<Data,Error>> {
        return Observable.create { observer in
            if let error = error {
                observer.onNext(.failure(error))
                observer.onCompleted()
                return Disposables.create()
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                observer.onNext(.failure(NetworkError.urlResponse))
                observer.onCompleted()
                return Disposables.create()
            }
            
            guard let data = data else {
                observer.onNext(.failure(NetworkError.emptyData))
                observer.onCompleted()
                return Disposables.create()
            }
            
            observer.onNext(.success(data))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    private func decode<T: Decodable>(data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.emptyData)
        }
    }
}
