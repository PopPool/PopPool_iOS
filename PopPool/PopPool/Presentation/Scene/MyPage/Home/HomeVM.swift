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
        let searchQuery: Observable<String>
        let myHomeAPIResponse: Observable<GetHomeInfoResponse>

    }

    struct Output {
        let searchResults: Observable<[PopUpStore]>
        var myHomeAPIResponse: Observable<GetHomeInfoResponse>

    }
    
    var generalPopUpStore: [HomePopUp] = []
    var customPopUpStore: BehaviorRelay<[HomePopUp]> = BehaviorRelay(value: [])
    var newPopUpStore: BehaviorRelay<[HomePopUp]> = BehaviorRelay(value: [])
    var popularPopUpStore: BehaviorRelay<[HomePopUp]> = BehaviorRelay(value: [])
    
    var myHomeAPIResponse: BehaviorRelay<GetHomeInfoResponse> = .init(
        value: .init(
            customPopUpStoreList: [],
            loginYn: true
        ))
    var disposeBag = DisposeBag()

    private let searchViewModel: SearchViewModel
    private let useCase: HomeUseCase

    init(searchViewModel: SearchViewModel = SearchViewModel(), useCase: HomeUseCase) {
        self.searchViewModel = searchViewModel
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        // 검색어를 SearchViewModel에 바인딩
        input.searchQuery
            .bind(to: searchViewModel.input.searchQuery)
            .disposed(by: disposeBag)

        // 검색 결과를 Output으로 전달
        return Output(
            searchResults: searchViewModel.output.searchResults,
            myHomeAPIResponse: myHomeAPIResponse.asObservable()

        )
    }
}
