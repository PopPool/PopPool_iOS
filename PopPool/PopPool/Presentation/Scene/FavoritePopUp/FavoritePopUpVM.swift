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
        case list = 0
        case grid = 1
        
        var title: String {
            switch self {
            case .list:
                "크게 보기"
            case .grid:
                "모아서 보기"
            }
        }
        
        var layout: UICollectionViewFlowLayout {
            switch self {
            case .list:
                let layout = UICollectionViewFlowLayout()
                let width = UIScreen.main.bounds.width - 40
                let height: CGFloat = 590
                layout.itemSize = .init(width: width, height: height)
                layout.minimumLineSpacing = 20
                layout.minimumInteritemSpacing = 0
                layout.scrollDirection = .vertical
                return layout
            case .grid:
                let layout = UICollectionViewFlowLayout()
                let width = (UIScreen.main.bounds.width - 40 - 8) / 2
                let height: CGFloat = 255
                layout.itemSize = .init(width: width, height: height)
                layout.minimumLineSpacing = 12
                layout.minimumInteritemSpacing = 8
                layout.scrollDirection = .vertical
                return layout
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
    
    var viewType: BehaviorRelay<ViewType> = .init(value: .list)
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
