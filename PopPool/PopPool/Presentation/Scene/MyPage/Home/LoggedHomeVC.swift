//
//  LoggedHomeVC.swift
//  PopPool
//
//  Created by Porori on 8/12/24.
//

import UIKit
import RxSwift
import SnapKit

final class LoggedHomeVC: BaseViewController {

    /// 홈을 섹션별로 구분합니다
    enum Section: Int, CaseIterable {
        case banner
        case recommendedHeader
        case recommended
        case interestHeader
        case interest
        case latestHeader
        case latest

        var items: Int {
            switch self {
            case .banner:
                return 4
            case .latestHeader, .interestHeader, .recommendedHeader:
                return 1
            default:
                return 6
            }
        }
    }

    private let header: SearchViewCPNT
//    private let viewModel: HomeVM
    private let userId: String




    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: self.setLayout())
        view.isScrollEnabled = true
        view.clipsToBounds = true
        view.contentInsetAdjustmentBehavior = .never
        view.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeCollectionViewCell.identifier
        )
        view.register(
            HomeDetailPopUpCell.self,
            forCellWithReuseIdentifier: HomeDetailPopUpCell.identifier
        )
        view.register(
            SectionHeaderCell.self,
            forCellWithReuseIdentifier: SectionHeaderCell.identifier
        )
        view.register(
            InterestViewCell.self,
            forCellWithReuseIdentifier: InterestViewCell.identifier
        )
        view.register(
            PopUpBackgroundView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PopUpBackgroundView.reuseIdentifer
        )

        // default 셀 등록
        view.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "DefaultCell"
        )
        return view
    }()

    //MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: HomeVM
    private var isLogin: Bool = false

    //MARK: - Initializer

    init(viewModel: HomeVM, userId: String) {
          self.viewModel = viewModel
        self.userId = userId

          self.header = SearchViewCPNT(viewModel: SearchViewModel())
        super.init()
      }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)

        let useCase = AppDIContainer.shared.resolve(type: HomeUseCase.self)

        useCase.fetchHome(
            userId: Constants.userId,
            page: 0,
            size: 6,
            sort: nil
        )
        .withUnretained(self)
        .subscribe(onNext: { (owner, response) in
            owner.viewModel.myHomeAPIResponse.accept(response)
            owner.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - Methods

    private func bind() {
        let searchQuery = header.searchBar.rx.text.orEmpty.asObservable()
        let input = HomeVM.Input(
            searchQuery: searchQuery,
            myHomeAPIResponse: viewModel.myHomeAPIResponse.asObservable() // 또는 적절한 Observable로 변경
        )
        let output = viewModel.transform(input: input)

        output.myHomeAPIResponse
              .withUnretained(self)
              .subscribe { (owner, response) in
                  if let loggedIn = response.loginYn {
                      self.isLogin = loggedIn
                      // 데이터별 연결
                  }
              }
              .disposed(by: disposeBag)
      }

    private func setUp() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let testVC = AlarmSettingVC(viewModel: AlarmSettingVM())
//        testVC.delegate = self
    }

    /// compositionalLayout을 구성하는 메서드
    /// - Returns: 섹션별로 UICollectionViewCompositionalLayout를 설정합니다
    private func setLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            guard let sectionType = Section(rawValue: section) else { return nil }

            switch sectionType {
            case .banner: return self.createBannerSection()
            case .recommendedHeader: return self.createSectionHeader(height: 84)
            case .recommended: return self.createHorizontalSection(width: 158, height: 249, behavior: .continuous)
            case .interestHeader:
                let section = self.createSectionHeader(height: 84)
                let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: PopUpBackgroundView.reuseIdentifer)
                section.decorationItems = [backgroundView]
                return section
            case .interest:
                let section = self.createHorizontalSection(width: 232, height: 332, behavior: .groupPaging)
                let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: PopUpBackgroundView.reuseIdentifer)
                section.decorationItems = [backgroundView]
                return section
            case .latestHeader: return self.createSectionHeader(height: 84)
            case .latest: return self.createHorizontalSection(width: 158, height: 249, behavior: .continuous)
            }
        }

        // 특정 section별로 다른 백그라운드 색상을 위한 backgroundView 등록
        layout.register(PopUpBackgroundView.self,
                        forDecorationViewOfKind: PopUpBackgroundView.reuseIdentifer)
        return layout
    }

    /// collectionView 상단의 배너 layout을 생성, 현재 값을 pageControl에 업데이트하는 메서드입니다
    /// - Returns: 배너의 LayoutSection을 반환합니다
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        section.visibleItemsInvalidationHandler = { [weak self] items , contentOffset, environment in
            guard let self = self else { return }

            let pageWidth = environment.container.contentSize.width / CGFloat(Section.banner.items)
            let bannerIndex = Int(round(contentOffset.x / pageWidth)) / Section.banner.items

            for item in items {
                let indexPath = item.indexPath
                if indexPath.section == Section.banner.rawValue,
                   let cell = self.collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell {
                    cell.pageIndex.onNext(bannerIndex)
                }
            }
        }
        return section
    }

    /// 섹션별 헤더 레이아웃을 구성합니다
    /// - Parameter height: 지정된 높이를 받습니다
    /// - Returns: 섹션별 서로 다른 높이를 가진 LayoutSection을 반환합니다
    private func createSectionHeader(height: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        return section
    }

    /// 가로용 섹션 레이아웃을 구성합니다
    /// - Parameters:
    ///   - width: 지정된 넓이 값을 받습니다
    ///   - height: 지정된 높이 값을 받습니다
    ///   - behavior: 상황에 따라 레이아웃에 담긴 아이템들이 스와이프에 어떻게 반응하는지 설정할 수 있습니다
    /// - Returns: LayoutSection 값을 반환합니다
    private func createHorizontalSection(width: CGFloat, height: CGFloat, behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        let itemPadding: CGFloat = 8
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: itemPadding, bottom: 0, trailing: itemPadding)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 20-itemPadding, bottom: 40, trailing: 20-itemPadding)
        return section
    }

    private func setUpConstraint() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension LoggedHomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Section(rawValue: section)?.items ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)

        guard let sectionType = Section(rawValue: indexPath.section) else {
            return defaultCell
        }

        switch sectionType {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell

            let totalCount = Section.banner.items
            if let customPopUpStores = viewModel.myHomeAPIResponse.value.customPopUpStoreList,
               indexPath.item < customPopUpStores.count {
                let homePopUp = customPopUpStores[indexPath.item]
                let imageUrlString = homePopUp.mainImageUrl
                cell.injectionWith(input: .init(
                    image: imageUrlString,
                    totalCount: totalCount)
                )
                return cell
            }
            return defaultCell

        case .recommendedHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.identifier, for: indexPath) as! SectionHeaderCell

            let id = viewModel.myHomeAPIResponse.value.nickname ?? "No Id"
            cell.configure(title: "\(id)님을 위한\n맞춤 팝업 큐레이션")

            cell.actionTapped
                .subscribe { _ in
                    guard self.navigationController?.topViewController == self else { return }

                    let vm = EntirePopupVM()
                    let response = self.viewModel.myHomeAPIResponse.value
                    let data: GetHomeInfoResponse = .init(
                        popularPopUpStoreList: response.popularPopUpStoreList,
                        popularPopUpStoreTotalPages: response.popularPopUpStoreTotalPages,
                        popularPopUpStoreTotalElements: response.popularPopUpStoreTotalElements
                    )
                    vm.response.accept(data)
                    let vc = EntirePopupVC(viewModel: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                .disposed(by: cell.disposeBag)
            return cell

        case .recommended:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell

            if let customPopUpStores = viewModel.myHomeAPIResponse.value.customPopUpStoreList,
               indexPath.item < customPopUpStores.count {
                let customPopUp = customPopUpStores[indexPath.item]
                let imageUrlString = customPopUp.mainImageUrl
                let category = customPopUp.category
                let title = customPopUp.name
                let location = customPopUp.address
                let date = customPopUp.startDate

                cell.injectionWith(input: HomeDetailPopUpCell.Input(
                    image: imageUrlString,
                    category: category,
                    title: title,
                    location: location,
                    date: date)
                )
                return cell
            }
            return defaultCell

        case .interestHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.identifier, for: indexPath) as! SectionHeaderCell

            cell.configureWhite(
                title: "팝풀이들은 지금 이런\n팝업에 가장 관심있어요"
            )
            return cell

        case .interest:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestViewCell.identifier, for: indexPath) as! InterestViewCell

            if let popularPopUpStores = viewModel.myHomeAPIResponse.value.popularPopUpStoreList,
               indexPath.item < popularPopUpStores.count {
                let popularPopUp = popularPopUpStores[indexPath.item]
                let imageUrlString = popularPopUp.mainImageUrl
                let category = popularPopUp.category
                let title = popularPopUp.name
                let location = popularPopUp.address
                let date = popularPopUp.startDate

                cell.injectionWith(input: .init(
                    image: imageUrlString,
                    category: category,
                    title: title,
                    location: location,
                    date: date)
                )
                return cell
            }
            return defaultCell

        case .latestHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.identifier, for: indexPath) as! SectionHeaderCell
            cell.configure(
                title: "제일 먼저 피드 올리는 신규 오픈 팝업"
            )
            cell.actionTapped
                .subscribe(onNext: {
                    guard self.navigationController?.topViewController == self else { return }

                    let vm = EntirePopupVM()
                    let response = self.viewModel.myHomeAPIResponse.value
                    let data: GetHomeInfoResponse = .init(
                        popularPopUpStoreList: response.newPopUpStoreList,
                        popularPopUpStoreTotalPages: response.newPopUpStoreTotalPages,
                        popularPopUpStoreTotalElements: response.newPopUpStoreTotalElements
                    )
                    vm.response.accept(data)
                    let vc = EntirePopupVC(viewModel: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                .disposed(by: cell.disposeBag)
            return cell

        case .latest:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell

            if let newPopUpStoreList = viewModel.myHomeAPIResponse.value.newPopUpStoreList,
               indexPath.item < newPopUpStoreList.count {
                let newPopUp = newPopUpStoreList[indexPath.item]
                let imageUrlString = newPopUp.mainImageUrl
                let category = newPopUp.category
                let title = newPopUp.name
                let location = newPopUp.address
                let date = newPopUp.startDate

                cell.injectionWith(input: HomeDetailPopUpCell.Input(
                    image: imageUrlString,
                    category: category,
                    title: title,
                    location: location,
                    date: date)
                )
                return cell
            }
            return defaultCell
        }
    }
}

//extension LoggedHomeVC: ActivityAlarmDelegate {
//    func activityToggled(image: UIImage?) {
//        header.rightBarButton.setImage(image, for: .normal)
//        print("헤더가 변경되었습니다.")
//    }
//}
