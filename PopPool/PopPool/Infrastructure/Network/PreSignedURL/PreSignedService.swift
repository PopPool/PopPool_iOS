//
//  PreSignedService.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/5/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa
import Alamofire

class PreSignedService {
    
    struct PresignedURLRequest {
        var filePath: String
        var image: UIImage
    }
    
    let tokenInterceptor = TokenInterceptor()
    
    func tryDelete(targetPaths: PresignedURLRequestDTO) -> Completable {
        let provider = ProviderImpl()
        let endPoint = PopPoolAPIEndPoint.presigned_delete(request: targetPaths)
        return provider.request(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func tryUpload(datas: [PresignedURLRequest]) -> Single<Void> {
        
        let methodDisposeBag = DisposeBag()
        
        return Single.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            
            getUploadLinks(request: .init(objectKeyList: datas.map { $0.filePath } ))
                .subscribe { response in
                    let responseList = response.preSignedUrlList
                    let inputList = datas
                    let requestList = zip(responseList, inputList).compactMap { zipResponse in
                        let urlResponse = zipResponse.0
                        let inputResponse = zipResponse.1
                        return self.uploadFromS3(url: urlResponse.preSignedUrl, image: inputResponse.image)
                    }
                    Single.zip(requestList)
                        .subscribe(onSuccess: { _ in
                            print("All images uploaded successfully")
                            observer(.success(()))
                        }, onFailure: { error in
                            print("Image upload failed: \(error.localizedDescription)")
                            observer(.failure(error))
                        })
                        .disposed(by: methodDisposeBag)
                } onError: { error in
                    print("getUploadLinks Fail: \(error.localizedDescription)")
                    observer(.failure(error))
                }
                .disposed(by: methodDisposeBag)
            return Disposables.create()
        }
    }
    
    func tryDownload(filePaths: [String]) -> Single<[UIImage]> {
        let methodDisposeBag = DisposeBag()
        
        return Single.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            
            // Download Links 요청
            self.getDownloadLinks(request: .init(objectKeyList: filePaths))
                .subscribe { response in
                    let responseList = response.preSignedUrlList
                    let requestList = responseList.compactMap { self.downloadFromS3(url: $0.preSignedUrl) }
                    
                    // 모든 다운로드 작업을 병렬로 수행
                    Single.zip(requestList)
                        .map { dataList -> [UIImage] in
                            return dataList.compactMap { UIImage(data: $0) }
                        }
                        .subscribe(onSuccess: { images in
                            print("All images downloaded successfully")
                            observer(.success(images))
                        }, onFailure: { error in
                            print("Image download failed: \(error.localizedDescription)")
                            observer(.failure(error))
                        })
                        .disposed(by: methodDisposeBag)
                    
                } onError: { error in
                    print("getDownloadLinks Fail: \(error.localizedDescription)")
                    observer(.failure(error))
                }
                .disposed(by: methodDisposeBag)
            
            return Disposables.create()
        }
    }
}


private extension PreSignedService {
    
    func uploadFromS3(url: String, image: UIImage) -> Single<Void> {
        return Single.create { single in
            if let imageData = image.jpegData(compressionQuality: 0),
               let url = URL(string: url)
            {
                let request = AF.upload(imageData, to: url, method: .put).response { response in
                    switch response.result {
                    case .success:
                        single(.success(()))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            } else {
                single(.failure(NSError(domain: "InvalidDataOrURL", code: -1, userInfo: nil)))
                return Disposables.create()
            }
        }
    }
    
    func downloadFromS3(url: String) -> Single<Data> {
        return Single.create { single in
            if let url = URL(string: url) {
                let request = AF.request(url).responseData { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(data))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            } else {
                single(.failure(NSError(domain: "InvalidDataOrURL", code: -1, userInfo: nil)))
                return Disposables.create()
            }
        }
    }
    
    func getUploadLinks(request: PresignedURLRequestDTO) -> Observable<PreSignedURLResponseDTO> {
        let provider = ProviderImpl()
        let endPoint = PopPoolAPIEndPoint.presigned_upload(request: request)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func getDownloadLinks(request: PresignedURLRequestDTO) -> Observable<PreSignedURLResponseDTO> {
        let provider = ProviderImpl()
        let endPoint = PopPoolAPIEndPoint.presigned_download(request: request)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor)
    }
}
