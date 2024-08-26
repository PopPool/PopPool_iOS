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
        let view = ListMenuViewCPNT(title: "총 0건", style: .filter("최신순"))
        return view
    }()
    
    private let normalCollectionView: UICollectionView = {
        let layout = GridLayout(height: 279)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .g50
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let instaCollectionView: UICollectionView = {
        let layout = GridLayout(height: 273)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .g50
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let viewModel: MyCommentedPopUpVM
    
    init(viewModel: MyCommentedPopUpVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        normalCollectionView.delegate = self
        normalCollectionView.dataSource = self
        normalCollectionView.register(PopUpCommentedCell.self, forCellWithReuseIdentifier: PopUpCommentedCell.identifier)
        instaCollectionView.delegate = self
        instaCollectionView.dataSource = self
        instaCollectionView.register(PopUpCommentedCell.self, forCellWithReuseIdentifier: PopUpCommentedCell.identifier)
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
        view.addSubview(normalCollectionView)
        normalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(listFilterView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(instaCollectionView)
        instaCollectionView.snp.makeConstraints { make in
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
        
        headerView.leftBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.moveToBottomModalVC
            .withUnretained(self)
            .subscribe { (owner, _) in
                let vc = MyCommentedPopUpModalVC(viewModel: owner.viewModel)
                owner.presentModalViewController(viewController: vc)
            }
            .disposed(by: disposeBag)
        
        output.sortedButtonResponse
            .withUnretained(self)
            .subscribe { (owner, selectedIndex) in
                owner.listFilterView.rightLabel.text = selectedIndex == 0 ? "최신순" : "반응순"
                owner.normalCollectionView.reloadData()
                owner.instaCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.normalCommentList
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.normalCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.instaCommentList
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.instaCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        segmentControlMenuView.rx.selectedSegmentIndex
            .withUnretained(self)
            .bind { (owner, index) in
                if index == 0 {
                    let count = owner.viewModel.instaCommentList.value.totalElements
                    owner.listFilterView.titleLabel.text = "총 \(count)건"
                    owner.normalCollectionView.isHidden = true
                    owner.instaCollectionView.isHidden = false
                    owner.instaCollectionView.reloadData()
                } else {
                    let count = owner.viewModel.normalCommentList.value.totalElements
                    owner.listFilterView.titleLabel.text = "총 \(count)건"
                    owner.normalCollectionView.isHidden = false
                    owner.instaCollectionView.isHidden = true
                    owner.normalCollectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MyCommentedPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var normalList = viewModel.normalCommentList.value
        var instaList = viewModel.instaCommentList.value
        if collectionView == normalCollectionView {
            return normalList.myCommentList.count
        } else {
            return instaList.myCommentList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PopUpCommentedCell.identifier,
            for: indexPath
        ) as? PopUpCommentedCell else { return UICollectionViewCell() }
        
        print("ReloadCollectionView~!~!~!~!~!~!")
        if collectionView == normalCollectionView {
            let normalData = viewModel.normalCommentList.value.myCommentList[indexPath.row]
            cell.injectionWith(
                input: .init(
                    imageURL: normalData.popUpStoreInfo.mainImageUrl,
                    commentType: .normal,
                    title: normalData.popUpStoreInfo.popUpStoreName,
                    content: normalData.content,
                    date: normalData.createDateTime.asString()
                )
            )
        } else {
            let instaData = viewModel.instaCommentList.value.myCommentList[indexPath.row]
            cell.injectionWith(
                input: .init(
                    imageURL: instaData.popUpStoreInfo.mainImageUrl,
                    commentType: .instagram,
                    title: nil,
                    content: instaData.content,
                    date: instaData.createDateTime.asString()
                )
            )
        }
        return cell
    }
}
