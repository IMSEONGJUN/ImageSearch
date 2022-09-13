//
//  ViewType.swift
//  SmoothyAssingment
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import RxSwift

// MARK: - BaseView Protocol

protocol ViewType: AnyObject {
    
    associatedtype ViewModel: ViewModelType
    
    var viewModel: ViewModel { get }
    var disposeBag: DisposeBag { get set }
    
    init(viewModel: ViewModel)
    func setupUI()
    func bind()
}

class RxMVVMViewController<T: ViewModelType>: UIViewController, ViewType {
    typealias T = ViewModel
    
    var viewModel: T
    var disposeBag: DisposeBag
    
    required init(viewModel: T) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    convenience init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {}
    func bind() {}
}
