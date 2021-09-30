//
//  ImageSearchController.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

protocol ImageSearchViewModelBindable: ViewModelType {
    // Action -> ViewModel
    var searchKeyword: PublishRelay<String> { get }
    var didScrollToBottom: PublishRelay<Void> { get }
    var searchButtonTapped: PublishRelay<Void> { get }
    
    // ViewModel -> State
    var cellData: Driver<[Document]> { get }
    var reloadList: Signal<Void> { get }
    var errorMessage: Signal<String> { get }
}

final class ImageSearchController: UIViewController, ViewType {
    
    // MARK: - Properties
    var disposeBag: DisposeBag!
    var viewModel: ImageSearchViewModelBindable!
    
    private var collection: UICollectionView!
    private var flowLayout: UICollectionViewFlowLayout!

    private let searchController = UISearchController()
    private let tap = UITapGestureRecognizer()
    private var statusBar: UIView!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        if traitCollection.userInterfaceStyle == .dark {
//            navigationController?.navigationBar.backgroundColor = .white
//        } else {
//            navigationController?.navigationBar.backgroundColor = .white
//        }
//    }
    
    // MARK: - Initial UI Setup
    func setupUI() {
        configureNavigationBar(with: TabBarTitle.imageSearchList, prefersLargeTitles: false)
        configureCollectionView()
        configureSearchBar()
    }
    
    private func configureStatusBar() {
        statusBar = UIApplication.statusBar
        guard let statusBar = statusBar else {return}
        statusBar.backgroundColor = .systemBackground
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        window?.addSubview(statusBar)
    }
    
    private func configureCollectionView() {
        collection = UICollectionView(frame: view.frame,
                                      collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: self.view))
        collection.backgroundColor = .systemBackground
        collection.register(ImageCell.self, forCellWithReuseIdentifier: String(describing: ImageCell.self))
        view.addSubview(collection)
    }
    
    private func configureSearchBar() {
        searchController.searchBar.placeholder = SearchBarPlaceHolder.search
        searchController.searchBar.tintColor = .green
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    
    // MARK: - Automatic Binding
    func bind() {
        
        // Action -> ViewModel
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.searchKeyword)
            .disposed(by: disposeBag)
            
        searchController.searchBar.rx.searchButtonClicked
            .do(onNext:{ [weak self] _ in self?.searchController.dismiss(animated: true) })
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
            
        collection.rx.needToFetchMoreData
            .filter { $0 }
            .mapToVoid()
            .bind(to: viewModel.didScrollToBottom)
            .disposed(by: disposeBag)
        
        
        // State -> View
        viewModel.cellData
            .drive(collection.rx.items(cellIdentifier: String(describing: ImageCell.self),
                                       cellType: ImageCell.self)) { indexPath, document, cell in
                cell.cellData = document
            }
            .disposed(by: disposeBag)
        
        viewModel.reloadList
            .emit(with: self) { owner, _ in
                owner.collection.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(onNext: {
                Toast(text: $0, delay: 0, duration: 1).show()
            })
            .disposed(by: disposeBag)
        
        
        // UI Binding
        collection.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                owner.searchController.dismiss(animated: true)
                guard let cell = owner.collection.cellForItem(at: indexPath) as? ImageCell else { return }
                let image = cell.imageView.image
                let vc = ImageDetailController()
                vc.setImage(image)
                self.navigationController?.pushViewController(vc, animated: true)
                print("onNext")
            },
            onError: { _, _ in
                print("onDisposed")
            },
            onCompleted: { _  in
                print("onCompleted!!")
            }
            )
            .disposed(by: disposeBag)
    }
}

