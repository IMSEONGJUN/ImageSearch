//
//  FavoriteController.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

final class FavoriteController: RxMVVMViewController<FavoriteViewModel> {

    // MARK: - Properties
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
    override func setupUI() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 250
        tableView.refreshControl = refresh
        tableView.register(FavoriteImageCell.self, forCellReuseIdentifier: String(describing: FavoriteImageCell.self))
    }
    
    
    // MARK: - Automatic Binding
    override func bind() {
        bindInput()
        bindOutput()
        navigationBind()
    }
    
    private func bindInput() {
        rx.viewWillAppear
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        
        refresh.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refreshPulled)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.cellData
            .drive(tableView.rx.items(cellIdentifier: String(describing: FavoriteImageCell.self),
                                      cellType: FavoriteImageCell.self)) { indexPathRow, document, cell in
                cell.cellData = document
            }
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .emit(onNext: {
                Toast(text: $0, delay: 0, duration: 1).show()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.loadingCompleted
            .map(!)
            .emit(to: refresh.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func navigationBind() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                print("item Tapped!!")
                guard let cell = self.tableView.cellForRow(at: indexPath) as? FavoriteImageCell else { return }
                let image = cell.favoriteImageView.image
                let vc = ImageDetailController()
                vc.setImage(image)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
