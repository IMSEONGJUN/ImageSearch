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
import Toaster

final class FavoriteImageViewController: BaseViewController<FavoriteImageViewModel> {
    
    private let tableView = UITableView()
    private let unmarkFavoriteSubject = PublishSubject<ImageInfo>()
    private var favoriteImageCoordinator: FavoriteImageCoordinator? {
        coordinator as? FavoriteImageCoordinator
    }
    
    override var navigationBarStyle: BaseNavigationController.NavigationBarStyle? {
        BaseNavigationController.NavigationBarStyle.none
    }
    
    override func bind() {
        let output = viewModel.transform(ViewModel.Input(unmarkFavorite: unmarkFavoriteSubject.asObservable()))
        
        let dataLoaded = output.dataSource
            .compactMap { result -> [ImageInfo]? in
                if case let .success(imageInfos) = result {
                    return imageInfos
                }
                return nil
            }
        
        let dataLoadingError = output.dataSource
            .compactMap { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.rawValue
            }
        
        dataLoaded
            .drive(tableView.rx.items(cellIdentifier: String(describing: FavoriteImageCell.self),
                                      cellType: FavoriteImageCell.self)) { [weak self] indexPathRow, imageInfo, cell in
                guard let owner = self else { return }
                cell.configureCell(item: imageInfo, unmarkFavoriteSubject: owner.unmarkFavoriteSubject)
            }
            .disposed(by: disposeBag)
        
        dataLoadingError
            .drive(onNext: {
                Toast(text: $0, delay: 0, duration: 1).show()
            })
            .disposed(by: disposeBag)
        
        output.unmarkDone
            .drive(onNext: { error in
                if let error {
                    Toast(text: error.rawValue, delay: 0, duration: 1).show()
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ImageInfo.self)
            .subscribe(with: self) { owner, imageInfo in
                owner.favoriteImageCoordinator?.showDetailImageViewController(imageUrlString: imageInfo.imageUrl)
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
