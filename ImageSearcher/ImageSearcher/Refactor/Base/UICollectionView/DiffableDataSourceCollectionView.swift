//
//  DiffableDataSourceCollectionView.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit

final class DiffableDataSourceCollectionView<Section: Hashable, Item: Hashable>: UICollectionView {
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    init(frame: CGRect = .zero,
         layoutProvider: some CollectionViewLayoutProvidable<Section, Item>,
         cellProvider: @escaping UICollectionViewDiffableDataSource<Section, Item>.CellProvider) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.diffableDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: cellProvider)
        collectionViewLayout = layoutProvider.createLayout(dataSource: diffableDataSource)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(_ snapshot: NSDiffableDataSourceSnapshot<Section, Item>, animatingDifferences: Bool) {
        self.diffableDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func refresh(sectionModels: [some SectionModeling<Section, Item>], animatingDifferences: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        sectionModels.forEach {
            snapshot.appendSections([$0.section])
            snapshot.appendItems($0.items)
        }
        
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func append(sectionModels: [some SectionModeling<Section, Item>], animatingDifferences: Bool) {
        guard var snapshot = diffableDataSource?.snapshot() else { return }
        
        sectionModels.forEach {
            snapshot.appendItems($0.items, toSection: $0.section)
        }
        
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func remove(for indexPaths: [IndexPath], animatingDifferences: Bool) {
        guard var snapshot = diffableDataSource?.snapshot() else { return }
        let items = indexPaths.compactMap {
            diffableDataSource?.itemIdentifier(for: $0)
        }
        
        snapshot.deleteItems(items)
        
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func remove(for indexPath: IndexPath, animatingDifferences: Bool) {
        guard var snapshot = diffableDataSource?.snapshot(),
              let item = item(for: indexPath) else { return }
        
        snapshot.deleteItems([item])
        
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func remove(for items: [Item], animatingDifferences: Bool) {
        guard var snapshot = diffableDataSource?.snapshot() else { return }
        
        snapshot.deleteItems(items)

        apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func reconfigureItem(at indexPath: IndexPath) {
        guard let item = item(for: indexPath), var snapshot = diffableDataSource?.snapshot() else {
            return
        }
        snapshot.reconfigureItems([item])
        apply(snapshot, animatingDifferences: true)
    }
    
    func item(for indexPath: IndexPath) -> Item? {
        diffableDataSource?.itemIdentifier(for: indexPath)
    }
    
    func section(for index: Int) -> Section? {
        diffableDataSource?.sectionIdentifier(for: index)
    }
}
