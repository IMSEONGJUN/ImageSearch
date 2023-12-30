//
//  CollectionViewLayoutProvidable.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit

protocol CollectionViewLayoutProvidable<Section, Item> {
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    
    func createLayout(dataSource: UICollectionViewDiffableDataSource<Section, Item>?) -> UICollectionViewLayout
}

