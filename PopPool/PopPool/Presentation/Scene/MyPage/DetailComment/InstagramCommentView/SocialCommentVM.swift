//
//  InstagramVM.swift
//  PopPool
//
//  Created by Porori on 9/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SocialCommentVM: ViewModelable {
    
    struct GuideContent {
        var index: Int
        var image: String
        var title: String
    }
    
    struct Input {
        
    }
    
    struct Output {
        var content: Observable<GuideContent>
    }

    private let clipboardManager: ClipboardService
    var disposeBag = DisposeBag()
    var currentContentCount: Int {
        return self.contentRelay.value.count
    }
    
    let contentRelay: BehaviorRelay<[GuideContent]> = .init(value: [
        .init(index: 0, image: "step1", title: "아래 인스타그램 열기\n버튼을 터치해 앱 열기"),
        .init(index: 1, image: "step2", title: "원하는 피드의 이미지로 이동 후\n공유하기 > 링크복사 터치하기"),
        .init(index: 2, image: "step3", title: "아래 이미지 영역을 터치해 \n팝풀 앱으로 돌아오기"),
        .init(index: 3, image: "step4", title: "복사된 인스타 피드 이미지와\n함께할 글을 입력 후 등록하기"),
    ])
    let singleContent: BehaviorRelay<GuideContent> = .init(
        value: GuideContent(index: 0, image: "step1", title: "아래 인스타그램 열기\n버튼을 터치해 앱 열기"))
    
    init(clipboardManager: ClipboardService) {
        self.clipboardManager = clipboardManager
    }
    
    func updateView(for page: Int) {
        guard page >= 0 && page < currentContentCount else { return }
        
        let contents = contentRelay.value
        let updatedContent = GuideContent(
            index: contents[page].index,
            image: contents[page].image,
            title: contents[page].title)
        singleContent.accept(updatedContent)
    }
    
    func fetchImage() -> Observable<Data> {
        Observable.create { [weak self] observer in
            let link = self?.clipboardManager.getClipboard()
            
            self?.clipboardManager.parseImage(from: link) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    print("데이터 옴", data)
                    observer.onNext(data)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
            content: singleContent.asObservable()
        )
    }
}
