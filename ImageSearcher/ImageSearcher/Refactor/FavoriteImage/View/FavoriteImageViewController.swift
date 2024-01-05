//
//  FavoriteImageViewController.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavoriteImageViewController: BaseViewController<FavoriteImageViewModel> {
    
    private let tableView = UITableView()
    private let unmarkFavoriteSubject = PublishSubject<ImageInfo>()
    
    override func bind() {
        let output = viewModel.transform(ViewModel.Input(unmarkFavorite: unmarkFavoriteSubject.asObservable()))
        
        output.dataSource
            .drive(tableView.rx.items(cellIdentifier: String(describing: FavoriteImageCell.self),
                                      cellType: FavoriteImageCell.self)) { [weak self] indexPathRow, imageInfo, cell in
                guard let owner = self else { return }
                cell.configureCell(item: imageInfo, unmarkFavoriteSubject: owner.unmarkFavoriteSubject)
            }
            .disposed(by: disposeBag)
        
        output.unmarkDone.drive().disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                guard let cell = owner.tableView.cellForRow(at: indexPath) as? FavoriteImageCell,
                    let image = cell.image else { return }

                let viewController = ImageDetailController(image: image)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension FavoriteImageViewController: ViewConfigurable {
    func configureViews() {
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 250
        tableView.register(FavoriteImageCell.self, forCellReuseIdentifier: String(describing: FavoriteImageCell.self))
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
