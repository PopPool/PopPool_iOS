//
//  NormalCommentVM.swift
//  PopPool
//
//  Created by Porori on 9/9/24.
//

import Foundation
import RxSwift
import RxCocoa

class NormalCommentVM: ViewModelable {
    
    struct Input {
        var returnButtonTapped: ControlEvent<Void>
        var saveButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var returnToHome: Observable<Void>
        var notifySave: Observable<Void>
        var selectedImageCount: Observable<Int>
    }
    
    var selectedImages: Observable<[Data]> {
        return selectedImageRelay.asObservable()
    }
    
    var selectedImageCount: Observable<Int> {
        return selectedImageRelay.map { $0.count }
    }
    
    var disposeBag = DisposeBag()
    private let maxImageCount = 5
    private var selectedImageRelay = BehaviorRelay<[Data]>(value: [])
    
    func addImage(_ imageData: Data) {
        // 오!
        var currentImages = selectedImageRelay.value
        if currentImages.count < maxImageCount {
            currentImages.append(imageData)
            print("이미지 데이터 accept", imageData)
            selectedImageRelay.accept(currentImages)
        }
    }
    
    func removeImage(at index: Int) {
        print("데이터 삭제")
        var currentImages = selectedImageRelay.value
        if index < currentImages.count {
            currentImages.remove(at: index)
            selectedImageRelay.accept(currentImages)
        }
    }
    
    func getImage(at index: Int) -> Data? {
        let images = selectedImageRelay.value
        return index < images.count ? images[index] : nil
    }
    
    func transform(input: Input) -> Output {
        return Output(
            returnToHome: input.returnButtonTapped.asObservable(),
            notifySave: input.saveButtonTapped.asObservable(),
            selectedImageCount: selectedImageCount
        )
    }
}
