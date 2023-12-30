//
//  ImageSearchViewController.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit
import RxSwift

final class ImageSearchViewControllerNew: BaseViewController<ImageSearchViewModelNew> {
    typealias Section = ImageSearchResultSection
    typealias Item = ImageSearchResultItem
        
    lazy var collectionView = DiffableDataSourceCollectionView<Section, Item>(layoutProvider: createLayoutProvider()) { collectionView, indexPath, itemIdentifier in
        return UICollectionViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
    }
}

extension ImageSearchViewControllerNew: ViewConfigurable {
    func configureViews() {
        setupCollectionView()
    }
}

extension ImageSearchViewControllerNew: DiffableDataSourceCollectionViewUsing {
    func createLayoutProvider() -> any CollectionViewLayoutProvidable<Section, Item> {
        ImageSearchCollectionViewLayoutProvider()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
    }
}
