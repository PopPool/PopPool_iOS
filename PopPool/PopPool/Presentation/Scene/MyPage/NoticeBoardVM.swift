//
//  NoticeBoardVM.swift
//  PopPool
//
//  Created by Porori on 7/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NoticeBoardVM: ViewModelable {
    struct Input {
        // Viewcontroller에서 발생한 모든 이벤트
        let itemSelected: Observable<IndexPath>
    }
    
    struct Output {
        let notices: Observable<[NoticeContent]>
        let selectedNotice: Observable<NoticeContent>
    }
    
    var disposeBag = DisposeBag()
    
    let mockData: [NoticeContent] = [
        NoticeContent(id: 0, title: "test", writer: "testWriter", content: "alskflashvlslv"),
        NoticeContent(id: 1, title: "test1", writer: "testWriter1", content: "asdfaxcvqwe"),
        NoticeContent(id: 2, title: "test2", writer: "testWriter2", content: "ㅁㄴㅇㄹㅊㅁㄴㅇㄹ"),
        NoticeContent(id: 3, title: "test3", writer: "testWriter3", content: "ㅂㅈㅊㅋㅌㅍ")
    ]
    
    func transform(input: Input) -> Output {
        let noticeOutput = Observable.just(mockData)
        
        let selectedNotice = input.itemSelected
            .withLatestFrom(noticeOutput) { indexPath, notices in
                notices[indexPath.row]
            }
        
        return Output(
            notices: noticeOutput,
            selectedNotice: selectedNotice
        )
    }
}

struct NoticeContent {
    let id: Int
    let title: String
    let writer: String
    let content: String
}
