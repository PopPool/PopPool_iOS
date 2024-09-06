//
//  HomeVC.swift
//  PopPool
//
//  Created by Porori on 9/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeVC: BaseViewController, UICollectionViewDelegate {
    
    enum Section: Int, Hashable ,CaseIterable {
        case topBanner
        case custom
        case popular
        case new
        
        var titleText: String? {
            switch self {
            case .topBanner: return nil
            case .custom: return "님을 위한\n맞춤 팝업 큐레이션"
            case .popular: return "팝풀이들은 지금 이런\n팝업에 가장 관심있어요"
            case .new: return "제일 먼저 피드 올리는\n신규 오픈 팝업"
            }
        }
    }
    
    //MARK: - Components
    // HEADER 생성 필요
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setLayout())
    
    
    //MARK: - Properties
    private let viewModel: HomeVM
    private var dataSource: UICollectionViewDiffableDataSource<Section, HomePopUp>!
    private var isLoggedIn: Bool = true
    private var disposeBag = DisposeBag()
    private var userName: String?
    
    init(viewModel: HomeVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let useCase = AppDIContainer.shared.resolve(type: HomeUseCase.self)
        
        useCase.fetchHome(userId: Constants.userId, page: 0, size: 6, sort: nil)
        .withUnretained(self)
        .subscribe(onNext: { (owner, response) in
            owner.userName = response.nickname
            owner.viewModel.myHomeAPIResponse.accept(response)
            owner.viewModel.customPopUpStore.accept(response.customPopUpStoreList ?? [])
            print("총 맞춤 데이터", owner.viewModel.customPopUpStore)
            owner.viewModel.popularPopUpStore.accept(response.popularPopUpStoreList ?? [])
            owner.viewModel.newPopUpStore.accept(response.newPopUpStoreList ?? [])
        })
        .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        setUpDataSource()
        bind()
    }
    
    private func setUp() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        collectionView.register(HomeDetailPopUpCell.self,
                                forCellWithReuseIdentifier: HomeDetailPopUpCell.identifier)
        
        collectionView.register(InterestViewCell.self,
                                forCellWithReuseIdentifier: InterestViewCell.identifier)
        
        collectionView.register(SectionHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderCell.identifier)
    }
    
    private func setUpConstraint() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        Observable.combineLatest(
            viewModel.customPopUpStore,
            viewModel.popularPopUpStore,
            viewModel.newPopUpStore
        )
        .withUnretained(self)
        .subscribe(onNext: { (owner, stores) in
            let (customStores, popularStores, newStores) = stores
            
            var snapShot = NSDiffableDataSourceSnapshot<Section, HomePopUp>()
            snapShot.appendSections([.topBanner])
            snapShot.appendItems([
                // 배너 영역은 추가 수정 필요... fetch할 데이터 관련해서 한번 더 확인
                .init(id: 0, category: "배너", name: "제목", address: "주소"),
                .init(id: 1, category: "배너", name: "제목", address: "주소"),
                .init(id: 2, category: "배너", name: "제목", address: "주소"),
                .init(id: 3, category: "배너", name: "제목", address: "주소"),
                .init(id: 4, category: "배너", name: "제목", address: "주소")
                ], toSection: .topBanner)

            if owner.isLoggedIn {
                print("커스텀 데이터", customStores)
                print("커스텀 데이터 갯수", customStores.count)
                snapShot.appendSections([.custom])
                snapShot.appendItems(customStores, toSection: .custom)
            }
            
//            print("인기 데이터", popularStores)
//            print("인기 데이터 갯수", popularStores.count)
            snapShot.appendSections([.popular])
            snapShot.appendItems(popularStores, toSection: .popular)
            
//            print("신규 데이터", newStores)
//            print("신규 데이터 갯수", newStores.count)
            snapShot.appendSections([.new])
            snapShot.appendItems(newStores, toSection: .new)
            
            owner.dataSource.apply(snapShot, animatingDifferences: false)
            owner.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
    private func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, environment in
            
            guard let sectionType = self.dataSource?.snapshot().sectionIdentifiers[section] else { return nil }
            
            switch sectionType {
            case .topBanner:
                return self.buildBanner()
            case .custom:
                return UIHelper.buildSection(
                    width: 158, height: 249,
                    behavior: .continuous)
            case .popular:
                return UIHelper.buildSection(
                    width: 232, height: 332,
                    behavior: .groupPaging)
            case .new:
                return UIHelper.buildSection(
                    width: 158, height: 249,
                    behavior: .continuous)
            }
        }
    }
    
    private func buildBanner() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // pageControl 연결부
        
        return section
    }
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, HomePopUp>(
            collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
                
                guard let sectionType = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                    return nil
                }
                
                switch sectionType {
                case .topBanner:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
                    cell.injectionWith(
                        input: HomeCollectionViewCell.Input(
                            image: URL(string: ""),
                            totalCount: 5))
                    return cell
                    
                case .custom:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell
                    cell.injectionWith(input: HomeDetailPopUpCell.Input(
                        image: URL(string: ""),
                        category: "카테고리",
                        title: "제목",
                        location: "지역",
                        date: "뭔 날짜")
                    )
                    return cell
                    
                case .popular:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestViewCell.identifier, for: indexPath) as! InterestViewCell
                    cell.injectionWith(input: InterestViewCell.Input(
                        image: URL(string: ""),
                        category: "타입",
                        title: "인기 팝업",
                        location: "위치",
                        date: "날짜"
                    ))
                    return cell
                    
                case.new:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell
                    cell.injectionWith(input: HomeDetailPopUpCell.Input(
                        image: URL(string: ""),
                        category: "카테고리",
                        title: "제목",
                        location: "지역",
                        date: "어떤 애요?")
                    )
                    return cell
                }
            })
        
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            guard let self = self else { return nil }
            guard let sectionType = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                return nil
            }
            if kind == UICollectionView.elementKindSectionHeader {
                let header = self.collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderCell.identifier,
                    for: indexPath) as! SectionHeaderCell
                
                if let title = sectionType.titleText {
                    header.configure(title: title)
                    if let userName = userName, sectionType == .custom {
                        header.configure(title: userName+title)
                    }
                }
                header.actionTapped
                    .withUnretained(self)
                    .subscribe(onNext: { (owner, _) in
                        guard self.navigationController?.topViewController == self else { return }
                        let response = self.viewModel.myHomeAPIResponse.value
                        
                        switch sectionType {
                        case .topBanner: return
                        case .custom:
                            let data: GetHomeInfoResponse = .init(
                                customPopUpStoreList: response.customPopUpStoreList,
                                customPopUpStoreTotalPages: response.customPopUpStoreTotalPages,
                                customPopUpStoreTotalElements: response.customPopUpStoreTotalElements,
                                loginYn: owner.isLoggedIn
                            )
                            let vm = EntirePopupVM()
                            vm.fetchedResponse.accept(data)
                            let vc = EntirePopupVC(viewModel: vm)
                            vc.header.titleLabel.text = "큐레이션 팝업 전체보기"
                            owner.navigationController?.pushViewController(vc, animated: true)
                            
                        case .popular:
                            let data: GetHomeInfoResponse = .init(
                                popularPopUpStoreList: response.popularPopUpStoreList,
                                popularPopUpStoreTotalPages: response.popularPopUpStoreTotalPages, popularPopUpStoreTotalElements: response.popularPopUpStoreTotalElements,
                                loginYn: owner.isLoggedIn
                            )
                            let vm = EntirePopupVM()
                            vm.fetchedResponse.accept(data)
                            
                            let vc = EntirePopupVC(viewModel: vm)
                            vc.header.titleLabel.text = "인기 팝업 전체보기"
                            owner.navigationController?.pushViewController(vc, animated: true)
                            
                        case .new:
                            let data: GetHomeInfoResponse = .init(
                                newPopUpStoreList: response.newPopUpStoreList,
                                newPopUpStoreTotalPages: response.newPopUpStoreTotalPages,
                                newPopUpStoreTotalElements: response.newPopUpStoreTotalElements,
                                loginYn: owner.isLoggedIn)
                            let vm = EntirePopupVM()
                            vm.fetchedResponse.accept(data)
                            let vc = EntirePopupVC(viewModel: vm)
                            vc.header.titleLabel.text = "신규 팝업 전체보기"
                            owner.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                    .disposed(by: self.disposeBag)
                
                return header
            }
            return nil
        }
    }
}
