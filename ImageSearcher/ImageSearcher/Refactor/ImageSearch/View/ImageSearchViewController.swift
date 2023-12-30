//
//  ImageSearchViewController.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit
import RxSwift

final class ImageSearchViewController: BaseViewController<ImageSearchViewModelNew> {
    typealias Section = ImageSearchResultSection
    typealias Item = ImageSearchResultItem
        
    lazy var collectionView = DiffableDataSourceCollectionView<Section, Item>(layoutProvider: createLayoutProvider()) { collectionView, indexPath, itemIdentifier in
        <#code#>
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
    }
}

extension ImageSearchViewController: ViewConfigurable {
    func configureViews() {
        setupCollectionView()
    }
}

extension ImageSearchViewController: DiffableDataSourceCollectionViewUsing {
    func createLayoutProvider() -> any CollectionViewLayoutProvidable<Section, Item> {
        ImageSearchCollectionViewLayoutProvider()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
    }
}
