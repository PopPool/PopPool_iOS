//
//  HomeVM.swift
//  PopPool
//
//  Created by Porori on 8/12/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeVM: ViewModelable {
    struct Input {
        
    }
    
    struct Output {
        var myHomeAPIResponse: Observable<GetHomeInfoResponse>
    }
    
    var generalPopUpStore: [HomePopUp] = [
        .init(id: 0, category: "패션", name: "이름이름", address: "주소주소"),
        .init(id: 1, category: "패션", name: "이름이름", address: "주소주소"),
        .init(id: 2, category: "패션", name: "이름이름", address: "주소주소"),
        .init(id: 3, category: "음식", name: "홀로롤로", address: "주소주소")
    ]
    
    var customPopUpStore: [HomePopUp] = [
        .init(id: 0, category: "밥", name: "욜루", address: "주소주소"),
        .init(id: 1, category: "밥", name: "욜룾2", address: "주소주소"),
        .init(id: 2, category: "밥", name: "욜루3", address: "주소주소"),
        .init(id: 3, category: "밥", name: "욜루4", address: "주소주소")
    ]
    
    var newPopUpStore: [HomePopUp] = [
        .init(id: 0, category: "음식", name: "욜루", address: "주소주소"),
        .init(id: 1, category: "음식", name: "욜룾2", address: "주소주소"),
        .init(id: 2, category: "음식", name: "욜루3", address: "주소주소"),
        .init(id: 3, category: "음식", name: "욜루4", address: "주소주소")
    ]
    
    var popularPopUpStore: [HomePopUp] = [
        .init(id: 0, category: "변경", name: "뭔데", address: "주소주소"),
        .init(id: 1, category: "변경", name: "뭔데2", address: "주소주소"),
        .init(id: 2, category: "변경", name: "뭔데3", address: "주소주소"),
        .init(id: 3, category: "변경", name: "뭔데4", address: "주소주소")
    ]
    
    var myHomeAPIResponse: BehaviorRelay<GetHomeInfoResponse> = .init(
        value: .init(
            customPopUpStoreList: [],
            loginYn: true
        ))
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        return Output(
            myHomeAPIResponse: myHomeAPIResponse.asObservable()
        )
    }
}
