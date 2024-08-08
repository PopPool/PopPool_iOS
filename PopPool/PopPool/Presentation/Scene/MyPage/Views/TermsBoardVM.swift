//
//  TermsBoardVM.swift
//  PopPool
//
//  Created by Porori on 7/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TermsBoardVM: ViewModelable {
    struct Input {
        let returnButtonTapped: ControlEvent<Void>
        let termSelected: Observable<IndexPath>
    }
    
    struct Output {
        let returnButtonTapped: ControlEvent<Void>
        let selectedTerm: Observable<[String]>
        let terms: Observable<[[String]]>
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    lazy var mockDataSubject = BehaviorSubject<[[String]]>(value: mockData)
    private let mockData: [[String]] = [
        ["서비스 이용약관", """
         하위의 텍스트는 모두 로렘 입숨입니다.
         
         모든 국민은 학문과 예술의 자유를 가진다. 모든 국민은 언론·출판의 자유와 집회·결사의 자유를 가진다. 헌법재판소는 법률에 저촉되지 아니하는 범위안에서 심판에 관한 절차, 내부규율과 사무처리에 관한 규칙을 제정할 수 있다. 국가는 농지에 관하여 경자유전의 원칙이 달성될 수 있도록 노력하여야 하며, 농지의 소작제도는 금지된다.
         
         국교는 인정되지 아니하며, 종교와 정치는 분리된다. 훈장등의 영전은 이를 받은 자에게만 효력이 있고, 어떠한 특권도 이에 따르지 아니한다. 모든 국민은 보건에 관하여 국가의 보호를 받는다. 모든 국민은 주거의 자유를 침해받지 아니한다. 주거에 대한 압수나 수색을 할 때에는 검사의 신청에 의하여 법관이 발부한 영장을 제시하여야 한다.
         
         국회의 정기회는 법률이 정하는 바에 의하여 매년 1회 집회되며, 국회의 임시회는 대통령 또는 국회재적의원 4분의 1 이상의 요구에 의하여 집회된다. 근로조건의 기준은 인간의 존엄성을 보장하도록 법률로 정한다. 국회의원의 선거구와 비례대표제 기타 선거에 관한 사항은 법률로 정한다. 대통령은 국민의 보통·평등·직접·비밀선거에 의하여 선출한다.
                 하위의 텍스트는 모두 로렘 입숨입니다.
        """],
        ["개인정보처리방침", "데이터가 있습니다1"],
        ["오픈소스라이선스", "데이터가 있습니다2"]
    ]
    
    // MARK: - Methods
    
    private func getTerms() -> Observable<[[String]]> {
        return mockDataSubject.asObservable()
    }
    
    // 삭제 기능
    func removeItem(at indexPath: IndexPath) {
        guard var currentData = try? mockDataSubject.value() else { return }
        currentData.remove(at: indexPath.row)
        mockDataSubject.onNext(currentData)
    }
    
    func transform(input: Input) -> Output {
        
        let selectedData = input.termSelected
            .withLatestFrom(mockDataSubject) { indexPath, terms in
                return terms[indexPath.row]
            }
        
        return Output(
            returnButtonTapped: input.returnButtonTapped,
            selectedTerm: selectedData,
            terms: getTerms()
        )
    }
}
