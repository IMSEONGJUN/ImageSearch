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
        topLeftItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let topLeftBottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(0.45))
        let topLeftBottomItem = NSCollectionLayoutItem(layoutSize: topLeftBottomItemSize)
        topLeftBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        topLeftBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))

        
//        let topMidItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .fractionalHeight(0.4))
//        let topMidItem = NSCollectionLayoutItem(layoutSize: topMidItemSize)
//        topMidItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
//        topMidItem.edgeSpacing = .init(leading: .none, top: .fixed(24), trailing: .none, bottom: .none)
//        
//        let topMidBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                                                         heightDimension: .fractionalHeight(0.6)))
//        topMidBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
//        topMidBottomItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(-24))
        
        let topRightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(0.65))
        let topRightItem = NSCollectionLayoutItem(layoutSize: topRightItemSize)
        topRightItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let topRightBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                           heightDimension: .fractionalHeight(0.35)))
        topRightBottomItem.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
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
