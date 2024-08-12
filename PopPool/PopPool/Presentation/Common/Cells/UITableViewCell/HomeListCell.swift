//
//  HomeListCell.swift
//  PopPool
//
//  Created by Porori on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// 확인 필요
final class HomeListCell: UITableViewCell {
    
    // MARK: - Components
    
    static let reuseIdentifier = "HomeListCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 68, height: 90)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = .init(top: 0, left: 20, bottom: 0, right: 0)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private var cellInputList: BehaviorRelay<[CircleFeedCell.Input]> = .init(value: [])
    
    private let disposeBag = DisposeBag()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension HomeListCell {
    
    func setUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CircleFeedCell.self, forCellWithReuseIdentifier: CircleFeedCell.identifier)
    }
    
    func setUpConstraints() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(90)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func bind() {
        cellInputList
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension HomeListCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellInputList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleFeedCell.identifier, for: indexPath) as! CircleFeedCell
        let input = cellInputList.value[indexPath.row]
        cell.injectionWith(input: input)
        return cell
    }
}

// MARK: - Cellable
extension HomeListCell: Cellable {

    struct Output {
        var didSelectCell: ControlEvent<IndexPath>
    }
    
    struct Input {
        var cellInputList: [HomeDetailPopUpCell.Input]
    }
    
    func injectionWith(input: Input) {
        
    }
    
    func getOutput() -> Output {
        return Output(
            didSelectCell: collectionView.rx.itemSelected
        )
    }
}

