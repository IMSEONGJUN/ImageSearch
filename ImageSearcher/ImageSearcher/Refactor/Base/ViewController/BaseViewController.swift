//
//  MVVMViewController.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol MVVMCViewType {
    associatedtype ViewModel: ViewModelable
    var viewModel: ViewModel { get }
    var coordinator: any Coordinator { get }
    var disposeBag: DisposeBag { get }
    
    init(viewModel: ViewModel, coordinator: some Coordinator)
    func bind()
}

class BaseViewController<ViewModel: ViewModelable>: UIViewController, MVVMCViewType {
    let viewModel: ViewModel
    let coordinator: any Coordinator
    var disposeBag = DisposeBag()
    
    required init(viewModel: ViewModel, coordinator: some Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        (self as? ViewConfigurable)?.configureViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {}
}
