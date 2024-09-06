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
            case .popular: return "인기 팝업이에요"
            case .new: return "신규 팝업이에요"
            case .custom: return "맞춤 팝업이에요"
            }
        }
    }
    
    // HEADER 생성 필요
    
    private let viewModel: HomeVM
    private var isLoggedIn: Bool = true
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, HomePopUp>!
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
                return self.buildSection(width: 158, height: 249, behavior: .continuous)
            case .popular:
                return self.buildSection(width: 232, height: 332, behavior: .groupPaging)
            case .new:
                return self.buildSection(width: 158, height: 249, behavior: .continuous)
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
    
    private func buildSection(width: CGFloat, height: CGFloat, behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> NSCollectionLayoutSection {
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
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 20 - itemPadding, bottom: 40, trailing: 20 - itemPadding)
        
        let height = CGFloat(Constants.spaceGuide.small300 + Constants.spaceGuide.small400 + 44)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
//    
//    private func personalizedSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .fractionalHeight(0.4))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .fractionalHeight(0.4))
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        return section
//    }
//    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, HomePopUp>(collectionView: collectionView,
                                                                            cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let sectionType = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
            
            switch sectionType {
            case .topBanner:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
                cell.backgroundColor = .yellow
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
        
        // 여기서 헤더 생성
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            guard let sectionType = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                return nil
            }
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderCell.identifier,
                    for: indexPath) as! SectionHeaderCell
                
                // 어떤 section인지 확인하고 넘기는 구조가 아니라 그냥 바로 넘기는 형태가 좋은가?
                if let title = sectionType.titleText {
                    header.configure(title: title)
                }
                header.actionTapped
                    .subscribe(onNext: {
                        print("버튼이 눌렸습니다22")
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
