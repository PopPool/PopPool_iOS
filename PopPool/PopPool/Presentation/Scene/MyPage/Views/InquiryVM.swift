//
//  InquiryVM.swift
//  PopPool
//
//  Created by Porori on 8/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class InquiryVM: ViewModelable {
    struct Input {
        
    }
    
    struct Output {
        var data: Observable<[[String]]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let test = [
            ["회원탈퇴 후 재가입이 가능한가요", "회원탈퇴 후 재가입이 가능한가요"],
            ["저장한 팝업은 어디서 볼 수 있나요?", "저장한 팝업은 어디서 볼 수 있나요"],
            ["추천은 어떤 기준으로 보여지나요?",
            """
            모든 국민은 학문과 예술의 자유를 가진다.
            모든 국민은 언론·출판의 자유와 집회·결사의 자유를 가진다. 헌법재판소는 법률에 저촉되지 아니하는
            범위안에서 심판에 관한 절차, 내부규율과
            사무처리에 관한 규칙을 제정할 수 있다.
            """]
        ]
        let mockData: Observable<[[String]]> = Observable.just(test)
        
        return Output(
            data:mockData
        )
    }
}
