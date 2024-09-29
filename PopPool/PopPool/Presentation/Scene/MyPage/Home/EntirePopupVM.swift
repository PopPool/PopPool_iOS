//
//  EntirePopupVM.swift
//  PopPool
//
//  Created by Porori on 8/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EntirePopupVM: ViewModelable {

    struct Input {

    }

    struct Output {
        let fetchedDataResponse: Observable<GetHomeInfoResponse>
        let allPopUps: Observable<[HomePopUp]>
    }

    var disposeBag = DisposeBag()
    var fetchedResponse: BehaviorRelay<GetHomeInfoResponse> = .init(value: GetHomeInfoResponse())
    private let allPopUpStores = BehaviorRelay<[HomePopUp]>(value: [])

    func transform(input: Input) -> Output {
        fetchedResponse
            .withUnretained(self)
            .subscribe(onNext: { (owner, response) in
                var allPopUps = [HomePopUp]()
                allPopUps.append(contentsOf: response.customPopUpStoreList ?? [])
                allPopUps.append(contentsOf: response.popularPopUpStoreList ?? [])
                allPopUps.append(contentsOf: response.newPopUpStoreList ?? [])
                owner.allPopUpStores.accept(allPopUps)
            })
            .disposed(by: disposeBag)


        return Output(
            fetchedDataResponse: fetchedResponse.compactMap { $0 }.asObservable(),
            allPopUps: allPopUpStores.asObservable()
        )
    }

    func updateDate(response: GetHomeInfoResponse) {
        print("DEBUG: updateDate 호출됨, response: \(response)")

        var allPopUps = [HomePopUp]()
        if let customPopUps = response.customPopUpStoreList { allPopUps.append(contentsOf: customPopUps) }
        if let popularPopUps = response.popularPopUpStoreList { allPopUps.append(contentsOf: popularPopUps) }
        if let newPopUps = response.newPopUpStoreList { allPopUps.append(contentsOf: newPopUps) }

        let uniquePopUps = Array(Set(allPopUps))

        print("DEBUG: 중복 제거 후 팝업 수: \(uniquePopUps.count)")

        if !uniquePopUps.isEmpty {
            allPopUpStores.accept(uniquePopUps)
            fetchedResponse.accept(response)
        } else {
            print("DEBUG: 모든 팝업 리스트가 비어있습니다.")
        }
    }


}
