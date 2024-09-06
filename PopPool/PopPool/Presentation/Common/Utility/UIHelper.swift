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
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
}
