//
//  ImageSearchController.swift
//  SmoothyAssingment
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

final class ImageSearchController: RxMVVMViewController<ImageSearchViewModel> {
    
    // MARK: - Properties
    private lazy var collectionView = UICollectionView(frame: view.frame,
                                                       collectionViewLayout: UIHelper.twoColumnLayout(in: view))
    private let searchController = UISearchController()
    private let tap = UITapGestureRecognizer()
    
    private let favoriteButtonTapSubject = PublishSubject<(Document, Int, PersistenceActionType)>()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            print("dark")
        } else {
            print("light")
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Initial UI Setup
    override func setupUI() {
        configureNavigationBar(with: TabBarTitle.imageSearchList, prefersLargeTitles: false)
        configureCollectionView()
        configureSearchBar()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = #colorLiteral(red: 0.9880631345, green: 0.9880631345, blue: 0.9880631345, alpha: 1)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: String(describing: ImageCell.self))
        view.addSubview(collectionView)
    }
    
    private func configureSearchBar() {
        searchController.searchBar.placeholder = SearchBarPlaceHolder.search
        searchController.searchBar.tintColor = .green
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    // MARK: - bind
    override func bind() {
        bindInput()
        bindOutput()
        navigationBind()
    }
    
    private func bindInput() {
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.searchKeyword)
            .disposed(by: disposeBag)
            
        searchController.searchBar.rx.searchButtonClicked
            .do(onNext:{ [weak self] _ in self?.searchController.dismiss(animated: true) })
            .bind(to: viewModel.input.searchButtonTapped)
            .disposed(by: disposeBag)
        
        collectionView.rx.needToFetchMoreData
            .filter { $0 }
            .mapToVoid()
            .bind(to: viewModel.input.didScrollToBottom)
            .disposed(by: disposeBag)
        
        favoriteButtonTapSubject
            .bind(to: viewModel.input.favoriteButtonSelected)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.dataSources
            .drive(collectionView.rx.items(cellIdentifier: String(describing: ImageCell.self),
                                       cellType: ImageCell.self)) { [weak self] index, document, cell in
                guard let self = self else { return }
                cell.configureCell(index: index, data: document, selectFavoriteButton: self.favoriteButtonTapSubject)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.didFinishFavoriteAction
            .emit(onNext: { [weak self] error, index in
                guard error == nil else { return }
                self?.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .emit(onNext: {
                Toast(text: $0, delay: 0, duration: 1).show()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigationBind() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.searchController.dismiss(animated: true)
                print("item Tapped!!")
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? ImageCell else { return }
                let image = cell.imageView.image
                let vc = ImageDetailController()
                vc.setImage(image)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

