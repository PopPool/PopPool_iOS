//
//  FavoritePopUpVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/27/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class FavoritePopUpVM: ViewModelable {

    enum ViewType: Int {
        case cardList = 0
        case grid = 1
        
        var title: String {
            switch self {
            case .cardList:
                "크게 보기"
            case .grid:
                "모아서 보기"
            }
        }
        
        var layout: UICollectionViewFlowLayout {
            switch self {
            case .cardList:
                return CardListLayout()
            case .grid:
                return GridLayout()
            }
        }
    }
    // MARK: - Input
    struct Input {
        var didTapFilterButton: ControlEvent<Void>
    }
    
    // MARK: - Output
    struct Output {
        var moveToFilterModalVC: ControlEvent<Void>
        var viewType: BehaviorRelay<ViewType>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    var viewType: BehaviorRelay<ViewType> = .init(value: .cardList)
    // MARK: - init
    init() {
        
    }
    
    func transform(input: Input) -> Output {

        return Output(
            moveToFilterModalVC: input.didTapFilterButton,
            viewType: viewType
        )
    }
}
