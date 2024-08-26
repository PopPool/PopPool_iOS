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
            case .banner: return 4
            case .latestHeader, .interestHeader, .recommendedHeader: return 1
            default: return 6
            }
        }
    }
    
    let imagePage = UIPageControl()
    let header = HeaderViewCPNT(title: "교체 예정", style: .icon(nil))
    
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
        return view
    }()
    
    private var viewModel: HomeVM
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bind() {
        let input = HomeVM.Input(fetchHome: Observable.just(())) // 이건 뭐지?
        let output = viewModel.transform(input: input)
        
        header.rx.rightButtonTap
            .subscribe(onNext: {
                print("버튼 탭")
            })
            .disposed(by: disposeBag)
        
        output.homeData
            .subscribe(onNext: { response in
                print("데이터를 뽑자", response)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUp() {        
        // viewModel 데이터 연결
        let useCase = AppDIContainer.shared.resolve(type: HomeUseCase.self)
        viewModel = HomeVM(useCase: useCase)
        
        // collectionView 연결
        collectionView.delegate = self
        collectionView.dataSource = self
        
        header.rightBarButton.setImage(UIImage(systemName: "lasso"), for: .normal)
        header.rightBarButton.isHidden = false
    }
    
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
        
        // 특정 section의 백그라운드 등록
        layout.register(PopUpBackgroundView.self,
                        forDecorationViewOfKind: PopUpBackgroundView.reuseIdentifer)
        return layout
    }
    
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
            
//            print("Content Offset: \(contentOffset.x)") // 실제 content의 x 값 (including invisible)
//            print("Item Width: \(pageWidth)") // 각 컴포넌트별 넓이 값
//            print("Banner Index: \(contentOffset.x / pageWidth)") // banner 개당 값
//            cell.pageIndex.onNext(bannerIndex)
            
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
    
    private func createSectionHeader(height: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        return section
    }
    
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
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch sectionType {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
            let totalCount = Section.banner.items
            
            cell.setImage(image: UIImage(named: "defaultLogo")) // 배너 이미지 설정
            cell.setUpPageControl(totalPage: totalCount) // 전체 갯수 업데이트
            return cell
            
        case .recommendedHeader, .latestHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.identifier, for: indexPath) as! SectionHeaderCell
            cell.configure(title: "집에 가고 싶어요 님을 위한\n맞춤 팝업 큐레이션")
            cell.actionTapped.subscribe { _ in
                print("전체보기가 눌렸습니다.")
                let vm = EntirePopupVM()
                let vc = EntirePopupVC(viewModel: vm)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: cell.disposeBag)
            return cell
            
        case .recommended, .latest:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailPopUpCell.identifier, for: indexPath) as! HomeDetailPopUpCell
            cell.injectionWith(input: HomeDetailPopUpCell.Input(
                image: UIImage(named: "defaultLogo"),
                category: "#카테고리",
                title: "일이삼사오육칠팔구십일이삼사오육칠팔구십",
                location: "서울시 송파구",
                date: "2024.07.03")
            )
            return cell
            
        case .interestHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.identifier, for: indexPath) as! SectionHeaderCell
            cell.configureWhite(
                title: "팝풀이들은 지금 이런\n팝업에 가장 관심있어요"
            )
            return cell
            
        case .interest:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestViewCell.identifier, for: indexPath) as! InterestViewCell
            cell.configure(
                title: "#8월 22일까지 열리는\n#패션, #성수동",
                category: "팝업스토어명 팝업스토어명",
                image: UIImage(named: "defaultLogo")
            )
            return cell
        }
    }
}
