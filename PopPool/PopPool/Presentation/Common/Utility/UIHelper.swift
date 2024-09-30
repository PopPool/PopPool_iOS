//
//  UIHelper.swift
//  PopPool
//
//  Created by Porori on 9/6/24.
//

import Foundation
import UIKit

enum UIHelper {
    
    static func buildSection(
        width: CGFloat,
        height: CGFloat,
        behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> NSCollectionLayoutSection {
        let itemPadding: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: 0, trailing: itemPadding)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 20, bottom: 40, trailing: 20)
        
        let height = CGFloat(Constants.spaceGuide.small300 + Constants.spaceGuide.small400 + 44)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        if behavior == .groupPaging {
            section.decorationItems = [createDarkBackground()]
        }
        return section
    }
    
    static func createDarkBackground() -> NSCollectionLayoutDecorationItem {
        let backgroundView = NSCollectionLayoutDecorationItem.background(elementKind: PopUpBackgroundView.reuseIdentifier)
        return backgroundView
    }
}
