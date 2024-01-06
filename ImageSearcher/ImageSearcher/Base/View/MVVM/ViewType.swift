//
//  ViewTypable.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewType {
    associatedtype ViewModel: ViewModelType
    var viewModel: ViewModel { get }
    var coordinator: any Coordinator { get }
    var disposeBag: DisposeBag { get }
    
    init(viewModel: ViewModel, coordinator: some Coordinator)
    func bind()
}
