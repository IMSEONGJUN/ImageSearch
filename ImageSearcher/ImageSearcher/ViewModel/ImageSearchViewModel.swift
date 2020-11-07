//
//  ImageSearchViewModel.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

struct ImageSearchViewModel: ImageSearchViewModelBindable {
    
    // Action with Value
    let searchKeyword = PublishRelay<String>()
    
    // Action with Void
    let didScrollToBottom = PublishRelay<Void>()
    let searchButtonTapped = PublishRelay<Void>()
    
    
    // State
    let cellData: Driver<[Document]>
    let reloadList: Signal<Void>
    let errorMessage: Signal<String>
    
    let disposeBag = DisposeBag()
    
    init(model: ImageSearchModel = ImageSearchModel()) {
        // Proxy
        let cellDataProxy = PublishRelay<[Document]>()
        cellData = cellDataProxy.asDriver(onErrorJustReturn: [])
        
        let reloadListProxy = PublishRelay<Void>()
        reloadList = reloadListProxy.asSignal()
        
        // Accumulator
        let cellDataAccumulator = BehaviorRelay<[Document]>(value: [])
        
        // Materials
        let page = PublishRelay<Int>()
        let isEnd = PublishRelay<Bool>()
        let valuesForSearch = Observable
            .combineLatest(
                page,
                searchKeyword
            )
            .filter{ $1 != "" }
        
        // MARK: Data Processing Step: [ Action check -> Mutate -> reduce State ]
        
        // MARK: - [Action 1].. < SearchBar Text Editing Action >
        
        // Mutate & Reduce Step
        searchKeyword
            .skip(1)
            .filter{ $0 == "" }
            .do(onNext: { _ in
                cellDataProxy.accept([])
                cellDataAccumulator.accept([])
                page.accept(1)
            })
            .map{ _ in Void()}
            .bind(to: reloadListProxy)
            .disposed(by: disposeBag)
        
        
        // MARK: - [Action 2]..< SearchButton Tap Action >
        
        // Mutate Step
        let imageInfo = searchButtonTapped
            .do(onNext: { _ in
                cellDataProxy.accept([])
                cellDataAccumulator.accept([])
                page.accept(1)
            })
            .withLatestFrom( valuesForSearch )
            .flatMapLatest{ page,key in
                return model.fetchImageInfo(page: page, searchKey: key)
            }
            .share()
        
        // Reduce Step
        imageInfo
            .map{ data -> [Document]? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value.documents
            }
            .filterNil()
            .do(onNext:{ cellDataAccumulator.accept($0) })
            .bind(to: cellDataProxy)
            .disposed(by: disposeBag)
        
        imageInfo
            .map{ data -> Bool? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value.meta.isEnd
            }
            .filterNil()
            .bind(to: isEnd)
            .disposed(by: disposeBag)
        
        errorMessage = imageInfo
            .map{ data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.message
            }
            .filterNil()
            .asSignal(onErrorJustReturn: NetworkError.defaultError.message ?? "")
        
        
        // MARK: - [Action 3]..< UICollectionView DidScroll To Bottom Action >
        
        // Mutate Step
        let additionalFetchedData = Observable
            .zip(
                didScrollToBottom,
                isEnd
            )
            .filter{ !$1 }
            .withLatestFrom( valuesForSearch )
            .map{ (pg, key) -> (Int, String) in
                let newPage = pg + 1
                page.accept(newPage)
                return (newPage, key)
            }
            .flatMapLatest {
                model.fetchImageInfo(page: $0, searchKey: $1)
            }
        
        let additionalCellData = additionalFetchedData
            .map{ data -> [Document]? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value.documents
            }
            .filterNil()
        
        let additionalIsEnd = additionalFetchedData
            .map{ data -> Bool? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value.meta.isEnd
            }
            .filterNil()
        
        // Reduce Step
        additionalCellData
            .map { (data) -> [Document] in
                var newAcc = cellDataAccumulator.value
                newAcc.append(contentsOf: data)
                return newAcc
            }
            .do(onNext:{ cellDataAccumulator.accept($0) })
            .bind(to: cellDataProxy)
            .disposed(by: disposeBag)
        
        additionalIsEnd
            .bind(to: isEnd)
            .disposed(by: disposeBag)
        
        
        // MARK: - [Action 4]..< Notification Action >
        
        // Mutate & Reduce Step
        NotificationCenter.default.rx.notification(Notifications.removeFavorite)
            .map{ _ in Void() }
            .bind(to: reloadListProxy)
            .disposed(by: disposeBag)
    }
}
