//
//  NormalCommentVM.swift
//  PopPool
//
//  Created by Porori on 9/9/24.
//

import Foundation
import RxSwift
import RxCocoa
import PhotosUI

class NormalCommentVM: ViewModelable {
    
    struct Input {
        var returnButtonTapped: ControlEvent<Void>
        var saveButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var returnToHome: Observable<Void>
        var notifySave: Observable<Void>
        var currentImageCount: Observable<Int>
    }
    
    var selectedImageCount: Observable<Int> {
        return selectedImageRelay.map { $0.count }
    }
    
    var disposeBag = DisposeBag()
    private let maxImageCount = 5
    private var selectedImageRelay = BehaviorRelay<[Data]>(value: [])
    
    func addImage(_ imageData: Data) {
        var currentImages = selectedImageRelay.value
        if currentImages.count < maxImageCount {
            currentImages.append(imageData)
            selectedImageRelay.accept(currentImages)
        }
    }
    
    func removeImage(at index: Int) {
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
            currentImageCount: selectedImageCount
        )
    }
}
