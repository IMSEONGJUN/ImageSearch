//
//  FavoriteController.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

protocol FavoriteViewModelBindable: ViewModelType {
    // Action -> ViewModel
    var viewWillAppear: PublishRelay<Void> { get }
    var refreshPulled: PublishRelay<Void> { get }
    var aTableViewRowDeleted: PublishRelay<Void> { get }
    
    // ViewModel -> State
    var cellData: Driver<[Document]> { get }
    var errorMessage: Signal<String> { get }
    var loadingCompleted: Driver<Bool> { get }
}

final class FavoriteController: UIViewController, ViewType {

    // MARK: - Properties
    var disposeBag: DisposeBag!
    var viewModel: FavoriteViewModelBindable!
    
    let tableView = UITableView()
    let refresh = UIRefreshControl()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar(with: TabBarTitle.favoriteImage, prefersLargeTitles: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - Initial UI Setup
    func setupUI() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 250
        tableView.refreshControl = refresh
        tableView.register(FavoriteImageCell.self, forCellReuseIdentifier: String(describing: FavoriteImageCell.self))
    }
    
    
    // MARK: - Automatic Binding
    func bind() {
        
        // Action -> ViewModel
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        refresh.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshPulled)
            .disposed(by: disposeBag)
        
        
        // ViewModel -> State
        viewModel.cellData
            .drive(tableView.rx.items(cellIdentifier: String(describing: FavoriteImageCell.self),
                                      cellType: FavoriteImageCell.self)) { indexPathRow, document, cell in
                cell.cellData = document
            }
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(onNext: {
                Toast(text: $0, delay: 0, duration: 1).show()
            })
            .disposed(by: disposeBag)
        
        viewModel.loadingCompleted
            .map{ !$0 }
            .drive(refresh.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        
        // UI Binding
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                guard let cell = self.tableView.cellForRow(at: indexPath) as? FavoriteImageCell else { return }
                let image = cell.favoriteImageView.image
                let vc = ImageDetailController()
                vc.setImage(image)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
