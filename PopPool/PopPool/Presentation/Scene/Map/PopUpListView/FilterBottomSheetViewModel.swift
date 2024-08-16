//
//  FilterBottomSheetViewModel.swift
//  PopPool
//
//  Created by 김기현 on 8/15/24.
//

import RxSwift
import RxCocoa

class FilterBottomSheetViewModel {
    private let filterUseCase: FilterUseCase
    private let disposeBag = DisposeBag()

    var selectedFilters = BehaviorRelay<[Filter]>(value: [])
    var locationData = BehaviorRelay<[Location]>(value: [])
    var categories = BehaviorRelay<[Category]>(value: [])

    init(filterUseCase: FilterUseCase) {
        self.filterUseCase = filterUseCase
    }

    func addFilter(_ filter: Filter) {
        filterUseCase.addFilter(filter)
            .subscribe(onSuccess: { [weak self] filters in
                self?.selectedFilters.accept(filters)
            })
            .disposed(by: disposeBag)
    }

    func removeFilter(_ filter: Filter) {
        filterUseCase.removeFilter(filter)
            .subscribe(onSuccess: { [weak self] filters in
                self?.selectedFilters.accept(filters)
            })
            .disposed(by: disposeBag)
    }

    func resetFilters() {
        filterUseCase.resetFilters()
            .subscribe(onSuccess: { [weak self] _ in
                self?.selectedFilters.accept([])
            })
            .disposed(by: disposeBag)
    }

    func applyFilters() {
        filterUseCase.applyFilters(selectedFilters.value)
            .subscribe(onCompleted: {
                // 완료 시 동작
            })
            .disposed(by: disposeBag)
    }
}
