//
//  ImageSearchViewController.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ImageSearchViewControllerNew: BaseViewController<ImageSearchViewModelNew> {
    typealias Section = ImageSearchResultSection
    typealias Item = ImageSearchResultItem
        
    lazy var collectionView = DiffableDataSourceCollectionView<Section, Item>(layoutProvider: createLayoutProvider())
    { [weak self] collectionView, indexPath, item in
        guard let owner = self else { return nil }
        switch item {
        case .image:
            let cell: ImageCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configureCell(item: item, selectFavoriteButton: owner.favoriteButtonTapSubject)
            return cell
        }
    }
    
    private let searchController = UISearchController()
    private let favoriteButtonTapSubject = PublishSubject<(Item, PersistenceUpdateType)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let searchKeyword = searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
        
        let searchButtonClick = searchController.searchBar.rx.searchButtonClicked
            .do(onNext:{ [weak self] _ in self?.searchController.dismiss(animated: true) })
        
        let input = ViewModel.Input(searchKeyword: searchKeyword,
                                    favoriteButtonSelected: favoriteButtonTapSubject.asObservable(),
                                    didScrollToBottom: collectionView.rx.needToFetchMoreData.asObservable(),
                                    searchButtonTapped: searchButtonClick)
        
        let output = viewModel.transform(input)
        
        output.dataLoaded
            .drive(collectionView.rx.dataSource)
            .disposed(by: disposeBag)
        
        output.updateFavorite
            .drive(with: self) { owner, item in
                owner.collectionView.reconfigureItems([item])
            }
            .disposed(by: disposeBag)
    }
}

extension ImageSearchViewControllerNew: ViewConfigurable {
    func configureViews() {
        setupCollectionView()
        configureSearchBar()
    }
}

extension ImageSearchViewControllerNew: DiffableDataSourceCollectionViewUsing {
    func createLayoutProvider() -> any CollectionViewLayoutProvidable<Section, Item> {
        ImageSearchCollectionViewLayoutProvider()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.registerCellClass(cellType: ImageCell.self)
    }
    
    private func configureSearchBar() {
        searchController.searchBar.placeholder = SearchBarPlaceHolder.search
        searchController.searchBar.tintColor = .green
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}

extension Reactive where Base == DiffableDataSourceCollectionView<ImageSearchResultSection, ImageSearchResultItem> {
    var dataSource: Binder<([ImageSearchResultSectionModel], ImageSearchViewModelNew.DataPresentType)> {
        Binder(base) { base, value in
            let (sectionModels, dataPresentType) = value
            switch dataPresentType {
            case .refresh: base.refresh(sectionModels: sectionModels, animatingDifferences: true)
            case .append: base.append(sectionModels: sectionModels, animatingDifferences: true)
            }
        }
    }
}
