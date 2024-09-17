//
//  ImageDownloadManager.swift
//  PopPool
//
//  Created by Porori on 9/17/24.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire

protocol ClipboardService {
    func getClipboard() -> String?
    func parseImage(from link: String?) -> Observable<Data>
}


final class ClipboardManager: ClipboardService {
    
    static let shared = ClipboardManager()
    private init() {}
    
    func getClipboard() -> String? {
        return UIPasteboard.general.hasStrings ? UIPasteboard.general.string : nil
    }
    
    func parseImage(from link: String?) -> Observable<Data> {
        return Observable.create { observer in
            do {
//                guard let link = link else { return as! Disposable }
                let endpoint = link! + "media/?size=l"
                AF.request(endpoint)
                    .validate()
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
            }
            return Disposables.create()
        }
    }
    
//    func parseImage(from link: String?, completed: @escaping (Result<Data, NetworkError>) -> Void) {
//        guard let link = link else { return }
//        let endpoint = link + "media/?size=l"
//        
//        guard let url = URL(string: endpoint) else {
//            completed(.failure(.decodeError))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("오류가 발생했습니다.", error.localizedDescription)
//            }
//            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.decodeError))
//                return
//            }
//            
//            do {
//                guard let data = data else { return }
//                completed(.success(data))
//            }
//        }
//        task.resume()
//    }
}
