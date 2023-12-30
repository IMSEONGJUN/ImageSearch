//
//  DiffableDataSourceCollectionViewUsing.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol DiffableDataSourceCollectionViewUsing {
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    
    var collectionView: DiffableDataSourceCollectionView<Section, Item> { get }
    
    func setupCollectionView()
    func createLayoutProvider() -> any CollectionViewLayoutProvidable<Section, Item>
}
