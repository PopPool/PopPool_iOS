//
//  FavoritePopUpVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavoritePopUpVC: BaseViewController {
    // MARK: - Components
    private let headerView: HeaderViewCPNT = {
        let view = HeaderViewCPNT(title: "찜한 팝업", style: .text(""))
        return view
    }()
    private let filterView: FilterMenuListViewCPNT = {
        let view = FilterMenuListViewCPNT(.init(title: "총 5건", filterTitle: "크게보기"))
        return view
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40
        let height: CGFloat = 590
        layout.itemSize = .init(width: width, height: height)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .g50
        view.isUserInteractionEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel = FavoritePopUpVM()
}

// MARK: - LifeCycle
extension FavoritePopUpVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

// MARK: - SetUp
private extension FavoritePopUpVC {
    
    func setUp() {
        view.backgroundColor = .g50
        self.navigationController?.navigationBar.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedPopUpCell.self, forCellWithReuseIdentifier: SavedPopUpCell.identifier)
        collectionView.register(ViewedPopUpCell.self, forCellWithReuseIdentifier: ViewedPopUpCell.identifier)
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(filterView)
        filterView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        // MARK: - Input
        let input = FavoritePopUpVM.Input(
            didTapFilterButton: filterView.filterButton.rx.tap
        )
        
        // MARK: - Output
        let output = viewModel.transform(input: input)
        output.moveToFilterModalVC
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.presentModalViewController(viewController: FavoritePopUpFilterModalVC(viewModel: owner.viewModel))
            }
            .disposed(by: disposeBag)
        output.viewType
            .withUnretained(self)
            .subscribe { (owner, viewType) in
                owner.filterView.injectionWith(input: .init(title: "총 5건", filterTitle: viewType.title))
                owner.collectionView.collectionViewLayout = viewType.layout
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension FavoritePopUpVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewType = viewModel.viewType.value
        
        switch viewType {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedPopUpCell.identifier, for: indexPath) as? SavedPopUpCell else {
                return UICollectionViewCell()
            }
            cell.injectionWith(input: .init(date: "yyyy.mm.dd - yyyy.mm.dd", title: "팝업스토어\n팝업스토어", address: "주소명 주소명"))
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewedPopUpCell.identifier, for: indexPath) as? ViewedPopUpCell else {
                return UICollectionViewCell()
            }
            cell.injectionWith(input: .init(date: "yyyy.mm.dd - yyyy.mm.dd", title: "팝업스토어\n팝업스토어"))
            return cell
        }
    }
}
