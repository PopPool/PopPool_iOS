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
    
    enum Section: CaseIterable {
        case header
        case recommended
        case interest
        case new
    }
    
    let header = HeaderViewCPNT(title: "교체 예정", style: .icon(nil))
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.setLayout())
        view.isScrollEnabled = true
        view.backgroundColor = .green
        view.clipsToBounds = true
        view.register(TestingHomeCollectionViewCell.self,
                      forCellWithReuseIdentifier: TestingHomeCollectionViewCell.identifier)
        
        view.register(HeaderViewCell.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: TestingHomeCollectionViewCell.identifier)
        return view
    }()
    
    private func setLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
              let itemFractionalWidthFraction = 1.0 / 3.0 // horizontal 3개의 셀
              let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
              let itemInset: CGFloat = 2.5
              
              // Item
              let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                heightDimension: .fractionalHeight(1)
              )
              let item = NSCollectionLayoutItem(layoutSize: itemSize)
              item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
              
              // Group
              let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(groupFractionalHeightFraction)
              )
              let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
              
              // Section
              let section = NSCollectionLayoutSection(group: group)
              section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
              
              // header / footer
              let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
              let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
              )
              let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
              )
              section.boundarySupplementaryItems = [header, footer]
              
              return section
            default:
              let itemFractionalWidthFraction = 1.0 / 5.0 // horizontal 5개의 셀
              let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
              let itemInset: CGFloat = 2.5
              
              // Item
              let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                heightDimension: .fractionalHeight(1)
              )
              let item = NSCollectionLayoutItem(layoutSize: itemSize)
              item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
              
              // Group
              let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(groupFractionalHeightFraction)
              )
              let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
              
              // Section
              let section = NSCollectionLayoutSection(group: group)
              section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
              return section
            }
          }
    }
    
    private let viewModel: HomeVM
    
    init(viewModel: HomeVM) {
        self.viewModel = viewModel
        super.init()
        setUp()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        
    }
    
    private func setUpConstraint() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension LoggedHomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let section = Section.allCases
        
//        switch section {
//        case .header:
//            return 10
//        case 1:
//            return 10
//        case 2:
//            return 10
//        case 3:
//            return 10
//        default:
//            return 0
//        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard var cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestingHomeCollectionViewCell.identifier, for: indexPath) as? TestingHomeCollectionViewCell else { return UICollectionViewCell(frame: .zero) }
        
//        switch indexPath.section {
//        case 0:
//            cell.backgroundColor = .purple
//            
//        case 1:
//            cell.backgroundColor = .red
//        case 2:
//            cell.backgroundColor = .orange
//        case 3:
//            cell.backgroundColor = .green
//        default:
//            cell.backgroundColor = .orange
//        }
        cell.setLabel(text: indexPath.description)
        return cell
    }
}
