//
//  ListLayout.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/06/02.
//

import UIKit

extension UICollectionViewLayout {
    static var list: UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            let accessoryItem = NSCollectionLayoutSupplementaryItem(
                layoutSize: .init(widthDimension: .estimated(20), heightDimension: .estimated(20)),
                elementKind: PinSupplementaryView.elementKind,
                containerAnchor: .init(edges: .trailing, absoluteOffset: .init(x: -16, y: 0))
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(28)),
                elementKind: HeaderSupplementaryView.elementKind,
                alignment: .top
            )
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [accessoryItem])
            item.contentInsets = .init(top: 1, leading: 0, bottom: 0, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(120))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                         subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.boundarySupplementaryItems = [headerItem]
            return section
        }
    }
}
