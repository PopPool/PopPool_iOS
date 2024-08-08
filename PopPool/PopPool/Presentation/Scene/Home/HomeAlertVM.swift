//
//  HomeAlertVM.swift
//  PopPool
//
//  Created by Porori on 8/8/24.
//

import Foundation
import RxSwift

class HomeAlertVM: ViewModelable {
    
    enum Section: CaseIterable {
        case today
        case all
        
        var sectionTitle: String {
            switch self {
            case .today: return "오늘"
            case .all: return "전체"
            }
        }
        
        var descriptionTitle: String? {
            switch self {
            case .today: return nil
            case .all: return "최근 30일 동안 수신한 알림을 보여드릴께요"
            }
        }
    }
    
    struct Input {
        
    }
    
    struct Output {
        let tableData: Observable<[String]>
        let sectionCount: Observable<Int>
    }
    
    init() {
        
    }
    
    let mockData: [String] = ["제목", "내용", "날짜"]
    var disposeBag = DisposeBag()
    
    func section(at index: Int) -> Section {
        return Section.allCases[index]
    }
    
    func transform(input: Input) -> Output {
        let dataOutput = Observable.just(mockData)
        let sectionData = Observable.just(Section.allCases)
        
        let sectionCount = sectionData.map { $0.count }
        
        return Output(
            tableData: dataOutput,
            sectionCount: sectionCount
        )
    }
}
