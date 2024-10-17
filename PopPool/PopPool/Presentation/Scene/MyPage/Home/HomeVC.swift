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
//        case custom
        case popular
        case new

        var titleText: String? {
            switch self {
            case .topBanner: return nil
//            case .custom: return "님을 위한\n맞춤 팝업 큐레이션"
            case .popular: return "팝풀이는 지금 이런\n팝업에 가장 관심있어요"
            case .new: return "제일 먼저 피드 올리는\n신규 오픈 팝업"
            }
        }
    }

    //MARK: - Components
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setLayout())
    private let searchComponent: SearchViewCPNT

    //MARK: - Properties
    private let viewModel: HomeVM
    private let tokenInterceptor: TokenInterceptor
    private let provider: Provider
    private var dataSource: UICollectionViewDiffableDataSource<Section, HomePopUp>!
    private var isLoggedIn: Bool = true
    private var disposeBag = DisposeBag()
    private var userName: String?

    init(viewModel: HomeVM, provider: Provider, tokenInterceptor: TokenInterceptor) {
        self.viewModel = viewModel
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
        self.searchComponent = SearchViewCPNT(viewModel: SearchViewModel(searchUseCase: AppDIContainer.shared.resolve(type: SearchUseCaseProtocol.self), recentSearchesViewModel: RecentSearchesViewModel()))
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let provider = AppDIContainer.shared.resolve(type: Provider.self)
        let tokenInterceptor = AppDIContainer.shared.resolve(type: TokenInterceptor.self)
        let useCase = AppDIContainer.shared.resolve(type: HomeUseCase.self)

        useCase.fetchHome(userId: Constants.userId, page: 0, size: 6, sort: nil)
        .withUnretained(self)
        .subscribe(onNext: { (owner, response) in

            owner.userName = response.nickname
            owner.viewModel.myHomeAPIResponse.accept(response)
            owner.viewModel.customPopUpStore.accept(response.customPopUpStoreList ?? [])
            owner.viewModel.popularPopUpStore.accept(response.popularPopUpStoreList ?? [])
            owner.viewModel.newPopUpStore.accept(response.newPopUpStoreList ?? [])
        })
        
        .disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)

        collectionView.register(HomeDetailPopUpCell.self,
                                forCellWithReuseIdentifier: HomeDetailPopUpCell.identifier)

        collectionView.register(PopularViewCell.self,
                                forCellWithReuseIdentifier: PopularViewCell.identifier)

        collectionView.register(SectionHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderCell.identifier)
    }

    private func setUpConstraint() {
        view.addSubview(collectionView)
        view.addSubview(searchComponent)

        searchComponent.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bind() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchBarTapped))
        searchComponent.addGestureRecognizer(tapGesture)
        
        Observable.combineLatest(
            viewModel.customPopUpStore,
            viewModel.popularPopUpStore,
            viewModel.newPopUpStore
        )
        .withUnretained(self)
        .subscribe(onNext: { (owner, stores) in
            let (customStores, popularStores, newStores) = stores
            var uniqueId = Set<Int64>()
            
            var snapShot = NSDiffableDataSourceSnapshot<Section, HomePopUp>()
            snapShot.appendSections([.topBanner, .popular, .new])
            
            snapShot.appendItems( [
                .init(id: 0, category: "dummy", name: "dummy", address: "dummy"),
                .init(id: 0, category: "dummy", name: "dummy", address: "dummy"),
                .init(id: 0, category: "dummy", name: "dummy", address: "dummy"),
                .init(id: 0, category: "dummy", name: "dummy", address: "dummy"),
                .init(id: 0, category: "dummy", name: "dummy", address: "dummy"),
                .init(id: 0, category: "dummy", name: "dummy", address: "dummy")
            ], toSection: .topBanner)
            
            popularStores.map { snapShot.appendItems( [
                .init(id: $0.id, category: $0.category, name: $0.name, address: $0.address)
            ], toSection: .popular) }
            newStores.map { snapShot.appendItems( [
                .init(id: $0.id, category: $0.category, name: $0.name, address: $0.address)
            ], toSection: .new) }
                        
            owner.dataSource.apply(snapShot, animatingDifferences: true)
        }, onError: { error in
            // 에러 처리
            print("API 호출 실패: \(error.localizedDescription)")
        })
        .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                print("탭된 인덱스", indexPath.item)
                let selectedPopUp = owner.viewModel.popularPopUpStore.value[indexPath.item]
                
                let provider = AppDIContainer.shared.resolve(type: Provider.self)
                let tokenInterceptor = AppDIContainer.shared.resolve(type: TokenInterceptor.self)

                let repository = DefaultPopUpRepository(provider: provider, tokenInterceptor: tokenInterceptor)
                let useCase = DefaultPopUpDetailUseCase(repository: repository)
                
                let detailViewModel = PopupDetailViewModel(useCase: useCase, popupId: selectedPopUp.id, userId: Constants.userId)
                let detailVC = PopupDetailViewController(viewModel: detailViewModel)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func searchBarTapped() {
        let searchService = AppDIContainer.shared.resolve(type: SearchServiceProtocol.self)
        let searchRepository = SearchRepository(searchService: searchService)
        let searchUseCase = SearchUseCase(repository: searchRepository)
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase, recentSearchesViewModel: RecentSearchesViewModel())

        let entirePopupVM = EntirePopupVM()

        let popularPopUps = viewModel.popularPopUpStore.value
        let response = GetHomeInfoResponse(
            popularPopUpStoreList: popularPopUps, 
            popularPopUpStoreTotalPages: viewModel.myHomeAPIResponse.value.popularPopUpStoreTotalPages,
            popularPopUpStoreTotalElements: viewModel.myHomeAPIResponse.value.popularPopUpStoreTotalElements,
            loginYn: viewModel.myHomeAPIResponse.value.loginYn
        )
        entirePopupVM.updateDate(response: response)


        entirePopupVM.updateDate(response: viewModel.myHomeAPIResponse.value)
        let searchVC = SearchViewController(
            viewModel: searchViewModel,
            entirePopupViewModel: entirePopupVM,
            homeViewModel: viewModel,
            provider: provider,
            tokenInterceptor: tokenInterceptor
        )

        navigationController?.pushViewController(searchVC, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }

    private func setLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, environment in

            guard let sectionType = self.dataSource?.snapshot().sectionIdentifiers[section] else { return nil }

            switch sectionType {
            case .topBanner:
                return self.buildBanner()
//            case .custom:
//                return UIHelper.buildSection(
//                    width: 158, height: 249,
//                    behavior: .continuous)
                
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
        
        layout.register(PopUpBackgroundView.self, forDecorationViewOfKind: PopUpBackgroundView.reuseIdentifier)
        return layout
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
                            image: nil,
                            totalCount: 5))
                    return cell
                    
                    print("데이터 팝업", indexPath)

                case .popular:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularViewCell.identifier, for: indexPath) as! PopularViewCell
                    
                    let popularItem = self.viewModel.popularPopUpStore.value[indexPath.item]
                    cell.injectionWith(input: PopularViewCell.Input(
                        image: popularItem.mainImageUrl,
                        category: popularItem.category,
                        title: popularItem.name,
                        location: popularItem.address,
                        date: popularItem.endDate
                    ))
                    return cell

                case.new:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell
                    let newItem = self.viewModel.newPopUpStore.value[indexPath.item]
                    
                    cell.injectionWith(input: HomeDetailPopUpCell.Input(
                        image: newItem.mainImageUrl,
                        category: newItem.category,
                        title: newItem.name,
                        location: newItem.address,
                        date: newItem.startDate)
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
                    if sectionType == .popular {
                        header.configure(title: title)
                    } else {
                        header.configureBlack(title: title)
                    }
//                    if let userName = userName, sectionType == .custom {
//                        header.configure(title: userName+title)
//                    }
                }
                header.actionTapped
                    .withUnretained(self)
                    .subscribe(onNext: { (owner, _) in
                        let response = self.viewModel.myHomeAPIResponse.value

                        switch sectionType {
                        case .topBanner: return
                        case .popular:
                            let data: GetHomeInfoResponse = .init(
                                popularPopUpStoreList: response.popularPopUpStoreList,
                                popularPopUpStoreTotalPages: response.popularPopUpStoreTotalPages,
                                popularPopUpStoreTotalElements: response.popularPopUpStoreTotalElements,
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
                    .disposed(by: header.disposeBag)

                return header
            }
            return nil
        }
    }
}
