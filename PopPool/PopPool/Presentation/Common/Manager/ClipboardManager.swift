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
            guard let link = link else {
                observer.onError(NetworkError.emptyData)
                return Disposables.create()
            }
            
            let endpoint = link + "media/?size=l"
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
            return Disposables.create()
        }
    }
}
