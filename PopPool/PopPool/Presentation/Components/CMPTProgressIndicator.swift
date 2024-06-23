//
//  CMPTProgressIndicator.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/23/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CMPTProgressIndicator: UIView {
    
    private var totalStep: BehaviorRelay<[Int]>
    private var nowStep:Int
    private var disposeBag = DisposeBag()
    
    private let progressCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .red
        return view
    }()
    
    init(totalStep: Int, startStep: Int) {
        self.totalStep = .init(value: (1...totalStep).map({ index in return Int(index) }))
        self.nowStep = startStep
        super.init(frame: .zero)
        self.backgroundColor = .gray
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CMPTProgressIndicator {
    func setUpConstraints() {
        self.addSubview(progressCollectionView)
        progressCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setUpBind() {
        
    }
}

