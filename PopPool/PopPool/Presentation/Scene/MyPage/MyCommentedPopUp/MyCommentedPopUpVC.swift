//
//  MyCommentedPopUpVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/11/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class MyCommentedPopUpVC: BaseViewController {

    // MARK: - Components
    private let headerView: HeaderViewCPNT = {
        let view = HeaderViewCPNT(title: "내가 쓴 코멘트", style: .text(""))
        return view
    }()

    private let segmentControlMenuView: SegmentedControlCPNT = {
        let view = SegmentedControlCPNT(type: .tab, segments: ["인스타그램", "일반"], selectedSegmentIndex: 0)
        return view
    }()
    
    private let listFilterView: ListMenuViewCPNT = {
        let view = ListMenuViewCPNT(title: "총 3건", style: .filter("최신순"))
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = GridLayout(height: 255)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .g50
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let viewModel: MyCommentedPopUpVM = MyCommentedPopUpVM()
}

// MARK: - LifeCycle
extension MyCommentedPopUpVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

// MARK: - SetUp
private extension MyCommentedPopUpVC {
    func setUp() {
        view.backgroundColor = .g50
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PopUpCommentedCell.self, forCellWithReuseIdentifier: PopUpCommentedCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(segmentControlMenuView)
        segmentControlMenuView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constants.spaceGuide.micro300)
            make.leading.trailing.equalToSuperview()
        }
        view.addSubview(listFilterView)
        listFilterView.snp.makeConstraints { make in
            make.top.equalTo(segmentControlMenuView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(listFilterView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bind() {
        
        let input = MyCommentedPopUpVM.Input(
            filterButtonTapped: listFilterView.filterButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.moveToBottomModalVC
            .withUnretained(self)
            .subscribe { (owner, _) in
                let vc = MyCommentedPopUpModalVC(viewModel: owner.viewModel)
                owner.presentModalViewController(viewController: vc)
            }
            .disposed(by: disposeBag)

        segmentControlMenuView.rx.selectedSegmentIndex
            .withUnretained(self)
            .bind { (owner, index) in
                if index == 0 {
                    owner.collectionView.collectionViewLayout = GridLayout(height: 273)
                } else {
                    owner.collectionView.collectionViewLayout = GridLayout(height: 279)
                }
                owner.collectionView.reloadData()
                owner.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension MyCommentedPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopUpCommentedCell.identifier, for: indexPath) as? PopUpCommentedCell else { return UICollectionViewCell() }
        if segmentControlMenuView.selectedSegmentIndex == 0 {
            cell.injectionWith(input: .init(
                imageURL: nil,
                isNormalComment: false,
                title: nil,
                content: "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf",
                date: "0000.00.00")
            )
        } else {
            cell.injectionWith(input: .init(
                imageURL: nil,
                isNormalComment: true,
                title: "as;dlfkjasd;flkj",
                content: "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf",
                date: "0000.00.00")
            )
        }
        return cell
    }
}
