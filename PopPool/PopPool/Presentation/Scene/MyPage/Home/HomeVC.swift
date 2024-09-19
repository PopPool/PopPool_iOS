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
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setLayout())
    private let searchComponent: SearchViewCPNT
    


    //MARK: - Properties
    private let viewModel: HomeVM
    private var dataSource: UICollectionViewDiffableDataSource<Section, HomePopUp>!
    private var isLoggedIn: Bool = true
    private var disposeBag = DisposeBag()
    private var userName: String?

    init(viewModel: HomeVM) {
        self.viewModel = viewModel
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

        let useCase = AppDIContainer.shared.resolve(type: HomeUseCase.self)

        useCase.fetchHome(userId: Constants.userId, page: 0, size: 6, sort: nil)
        .withUnretained(self)
        .subscribe(onNext: { (owner, response) in
            print("응답 데이터: \(response)")


            owner.userName = response.nickname
            owner.viewModel.myHomeAPIResponse.accept(response)
            owner.viewModel.customPopUpStore.accept(response.customPopUpStoreList ?? [])
            owner.viewModel.popularPopUpStore.accept(response.popularPopUpStoreList ?? [])
            owner.viewModel.newPopUpStore.accept(response.newPopUpStoreList ?? [])
            print("Custom PopUp Store: \(response.customPopUpStoreList ?? [])")
               print("Popular PopUp Store: \(response.popularPopUpStoreList ?? [])")
               print("New PopUp Store: \(response.newPopUpStoreList ?? [])")
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

        collectionView.register(InterestViewCell.self,
                                forCellWithReuseIdentifier: InterestViewCell.identifier)

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
            make.height.equalTo(80)
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
                snapShot.appendSections([.custom])
                snapShot.appendItems(customStores, toSection: .custom)
            }

            snapShot.appendSections([.popular])
            snapShot.appendItems(popularStores, toSection: .popular)

            snapShot.appendSections([.new])
            snapShot.appendItems(newStores, toSection: .new)

            owner.dataSource.apply(snapShot, animatingDifferences: false)
            owner.collectionView.reloadData()
        }, onError: { error in
              // 에러 처리
              print("API 호출 실패: \(error.localizedDescription)")
          })     
        .disposed(by: disposeBag)
    }
    @objc private func searchBarTapped() {
        let searchService = AppDIContainer.shared.resolve(type: SearchServiceProtocol.self)
        let searchRepository = SearchRepository(searchService: searchService)
        let searchUseCase = SearchUseCase(repository: searchRepository)
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase, recentSearchesViewModel: RecentSearchesViewModel())

        let searchVC = SearchViewController(viewModel: searchViewModel)

        navigationController?.pushViewController(searchVC, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }

    private func setLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, environment in

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
                            image: URL(string: ""),
                            totalCount: 5))
                    return cell

                case .custom:
                    let customItem = self.viewModel.customPopUpStore.value[indexPath.item]
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell
                    cell.injectionWith(input: HomeDetailPopUpCell.Input(
                        image: URL(string: ""),
                        category: customItem.category,
                        title: customItem.name,
                        location: customItem.address,
                        date: customItem.startDate)
                    )
                    return cell

                case .popular:
                    let popularItem = self.viewModel.popularPopUpStore.value[indexPath.item]

                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestViewCell.identifier, for: indexPath) as! InterestViewCell
                    cell.injectionWith(input: InterestViewCell.Input(
                        image: URL(string: ""),
                        category: popularItem.category,
                        title: popularItem.name,
                        location: "위치",
                        date: "날짜"
                    ))
                    return cell

                case.new:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell
                    let newItem = self.viewModel.newPopUpStore.value[indexPath.item]

                    cell.injectionWith(input: HomeDetailPopUpCell.Input(
                        image: URL(string: ""),
                        category: newItem.category,
                        title: newItem.name,
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
                        print("응답데이터: \(response)") // 로그 추가

                        switch sectionType {
                        case .topBanner: return
                        case .custom:

                                   guard let customPopUpStoreList = response.customPopUpStoreList, !customPopUpStoreList.isEmpty else {
                                       print("맞춤 팝업 데이터가 없습니다.")
                                       print(" 헤더 탭")
                                       return

                                   }
                            print("헤더탭탭")
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
