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
            case .custom: return "\(Constants.userId)님을 위한\n맞춤 팝업 큐레이션"
            case .popular: return "팝풀이들은 지금 이런\n팝업에 가장 관심있어요"
            case .new: return "제인 먼저 피드 올리는\n신규 오픈 팝업"
            }
        }
    }
    
    //MARK: - Components
    // HEADER 생성 필요
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setLayout())
    
    
    //MARK: - Properties
    private let viewModel: HomeVM
    private var dataSource: UICollectionViewDiffableDataSource<Section, HomePopUp>!
    private var isLoggedIn: Bool = false
    private var disposeBag = DisposeBag()
    
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
        
        useCase.fetchHome(
            userId: Constants.userId,
            page: 0,
            size: 6,
            sort: nil
        )
        .withUnretained(self)
        .subscribe(onNext: { (owner, response) in
            owner.viewModel.myHomeAPIResponse.accept(response)
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
        updateDataSource()
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
                }
                header.actionTapped
                    .withUnretained(self)
                    .subscribe(onNext: { (owner, _) in
                        print("버튼이 눌렸습니다22")
                        print("인덱스 값", indexPath)
                        print("section 값", indexPath.section)
                        print("어디에 있는가", sectionType)
                        switch sectionType {
                        case .topBanner: return
                        case .custom:
                            let response = self.viewModel.myHomeAPIResponse.value
                            let data: GetHomeInfoResponse = .init(
                                customPopUpStoreList: response.customPopUpStoreList,
                                customPopUpStoreTotalPages: response.customPopUpStoreTotalPages,
                                customPopUpStoreTotalElements: response.customPopUpStoreTotalElements,
                                loginYn: owner.isLoggedIn
                            )
                            let vm = EntirePopupVM()
                            vm.response.accept(data)
                            
                            let vc = EntirePopupVC(viewModel: vm)
                            vc.header.titleLabel.text = "큐레이션 팝업 전체보기"
                            owner.navigationController?.pushViewController(vc, animated: true)
                        case .popular:
                            let response = owner.viewModel.myHomeAPIResponse.value
                            let data: GetHomeInfoResponse = .init(
                                popularPopUpStoreList: response.popularPopUpStoreList,
                                popularPopUpStoreTotalPages: response.popularPopUpStoreTotalPages, popularPopUpStoreTotalElements: response.popularPopUpStoreTotalElements,
                                loginYn: owner.isLoggedIn
                            )
                            let vm = EntirePopupVM()
                            vm.response.accept(data)
                            
                            let vc = EntirePopupVC(viewModel: vm)
                            vc.header.titleLabel.text = "인기 팝업 전체보기"
                            owner.navigationController?.pushViewController(vc, animated: true)
                        case .new:
                            let response = owner.viewModel.myHomeAPIResponse.value
                            let data: GetHomeInfoResponse = .init(
                                newPopUpStoreList: response.newPopUpStoreList,
                                newPopUpStoreTotalPages: response.newPopUpStoreTotalPages,
                                newPopUpStoreTotalElements: response.newPopUpStoreTotalElements,
                                loginYn: owner.isLoggedIn)
                            let vm = EntirePopupVM()
                            vm.response.accept(data)
                            
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
    
    private func updateDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, HomePopUp>()
        
        let general = viewModel.generalPopUpStore
        let custom = viewModel.customPopUpStore
        let new = viewModel.newPopUpStore
        let popular = viewModel.popularPopUpStore
        
        snapShot.appendSections([.topBanner])
        snapShot.appendItems(general, toSection: .topBanner)
        
        if isLoggedIn {
            snapShot.appendSections([.custom])
            snapShot.appendItems(custom, toSection: .custom)
        }
        
        snapShot.appendSections([.popular])
        snapShot.appendItems(popular, toSection: .popular)
        
        snapShot.appendSections([.new])
        snapShot.appendItems(new, toSection: .new)
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
