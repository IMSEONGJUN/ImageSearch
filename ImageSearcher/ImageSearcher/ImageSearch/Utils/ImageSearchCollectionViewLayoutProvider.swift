//
//  ImageSearchCollectionViewLayoutProvider.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit

final class ImageSearchCollectionViewLayoutProvider: CollectionViewLayoutProvidable {
    typealias Section = ImageSearchResultSection
    typealias Item = ImageSearchResultItem
    
    func createLayout(dataSource: UICollectionViewDiffableDataSource<Section, Item>?) -> UICollectionViewLayout {
        let topLeftItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.55))
        let topLeftItem = NSCollectionLayoutItem(layoutSize: topLeftItemSize)
        topLeftItem.contentInsets = NSDirectionalEdgeInsets.init(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let topLeftBottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(0.45))
        let topLeftBottomItem = NSCollectionLayoutItem(layoutSize: topLeftBottomItemSize)
        topLeftBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 2, leading: 2, bottom: 2, trailing: 2)
        topLeftBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))
        
        let topRightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(0.65))
        let topRightItem = NSCollectionLayoutItem(layoutSize: topRightItemSize)
        topRightItem.contentInsets = NSDirectionalEdgeInsets.init(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let topRightBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                           heightDimension: .fractionalHeight(0.35)))
        topRightBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 2, leading: 2, bottom: 2, trailing: 2)
        topRightBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        
        let leftGroup = NSCollectionLayoutGroup.vertical(layoutSize:
            NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.5),
                                        heightDimension: .fractionalHeight(1.0)),
                                                         subitems: [topLeftItem, topLeftBottomItem])
        
        let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize:
            NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(0.5),
                                        heightDimension: .fractionalHeight(1.0)),
                                                        subitems: [topRightItem, topRightBottomItem])
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftGroup, rightGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
