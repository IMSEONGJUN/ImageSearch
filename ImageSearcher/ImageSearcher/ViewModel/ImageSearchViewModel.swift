//
//  ImageSearchViewModel.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

final class ImageSearchViewModel: ViewModelType {
    struct Input {
        let searchKeyword: AnyObserver<String>
        let favoriteButtonSelected: AnyObserver<(Document, Int, PersistenceActionType)>
        let didScrollToBottom: AnyObserver<Void>
        let searchButtonTapped: AnyObserver<Void>
    }

    struct Output {
        let dataSources: Driver<[Document]>
        let didFinishFavoriteAction: Signal<Int>
        let errorMessage: Signal<String>
    }
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let searchKeywordSubject = PublishSubject<String>()
    private let favoriteButtonSelected = PublishSubject<(Document, Int, PersistenceActionType)>()
    private let didScrollToBottomSubject = PublishSubject<Void>()
    private let searchButtonTappedSubject = PublishSubject<Void>()
    
<<<<<<< HEAD
    
    // State
    let cellData: Driver<[ImageInfo]>
    let reloadList: Signal<Void>
    let errorMessage: Signal<String>
    
    let disposeBag = DisposeBag()
    
    init(model: ImageSearchModel = ImageSearchModel()) {
        
        // Proxy
        let cellDataProxy = PublishRelay<[ImageInfo]>()
        cellData = cellDataProxy.asDriver(onErrorJustReturn: [])
=======
    init() {
        input = Input(searchKeyword: searchKeywordSubject.asObserver(),
                      favoriteButtonSelected: favoriteButtonSelected.asObserver(),
                      didScrollToBottom: didScrollToBottomSubject.asObserver(),
                      searchButtonTapped: searchButtonTappedSubject.asObserver())
        
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
        
        let errorMessage = PublishRelay<String>()
        
<<<<<<< HEAD
        let errorMessageProxy = PublishRelay<String>()
        errorMessage = errorMessageProxy.asSignal()
        
        // Accumulator
        let cellDataAccumulator = BehaviorRelay<[ImageInfo]>(value: [])
        
        // Materials
        let page = PublishRelay<Int>()
        let isEnd = PublishRelay<Bool>()
        let valuesForSearch = Observable
            .combineLatest(
                page,
                searchKeyword
            )
            .filter { $1 != "" }
=======
        output = Output(dataSources: dataSourceOutput(errorTracker: errorMessage),
                        didFinishFavoriteAction: modifyFavorite(errorTracker: errorMessage),
                        errorMessage: errorMessage.asSignal())
    }
    
    private func dataSourceOutput(errorTracker: PublishRelay<String>) -> Driver<[Document]> {
        let isEnd = BehaviorRelay<Bool>(value: false)
        let page = BehaviorRelay<Int>(value: 1)
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
        
        let reset = {
            page.accept(1)
            isEnd.accept(false)
        }
        
        let searchKeywordCleared = searchKeywordSubject
            .filter { $0.isEmpty }
            .do(onNext: { _ in reset() })
            .map { _ -> [Document] in [] }
        
        let searchButtonTapped = searchButtonTappedSubject
            .do(onNext: reset)
            .withLatestFrom(searchKeywordSubject)
            .withUnretained(self)
            .flatMapLatest { owner, keyword in
                owner.didScrollToBottomSubject
                    .startWith(())
                    .withLatestFrom(isEnd)
                    .filter { !$0 }
                    .withLatestFrom(page)
                    .flatMapLatest { page in
                        APIManager.shared.fetchImageInformation(page: page, searchKey: keyword)
                            .compactMap { data -> ImageInfo? in
                                switch data {
                                case .success(let value):
                                    return value
                                case .failure(let error):
                                    errorTracker.accept(error.localizedDescription)
                                    return nil
                                }
                            }
                            .do(onNext: {
                                isEnd.accept($0.meta.isEnd)
                            })
                            .map { $0.documents }
                    }
                    .scan([]) { prev, new in
                        new.isEmpty ? [] : prev + new
                    }
            }
            .do(onNext: { _ in
                let newpage = page.value + 1
                page.accept(newpage)
            })
        
<<<<<<< HEAD
        // Reduce Step
        imageInfo
            .map { data -> [ImageInfo]? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value.imageInfos
            }
            .filterNil()
            .do { cellDataAccumulator.accept($0) }
            .bind(to: cellDataProxy)
            .disposed(by: disposeBag)
        
        imageInfo
            .map { data -> Bool? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value.meta.isEnd
            }
            .filterNil()
            .bind(to: isEnd)
            .disposed(by: disposeBag)
        
        imageInfo
            .map { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.message
            }
            .filterNil()
            .bind(to: errorMessageProxy)
            .disposed(by: disposeBag)
        
        
        // MARK: - [Action 3]..< UICollectionView DidScroll to Bottom for additional fetched data Action >
        
        // Mutate Step
        let additionalFetchedData = Observable
            .zip(
                didScrollToBottom,
                isEnd
            )
            .filter { !$1 }
            .withLatestFrom( valuesForSearch )
            .map { (pg, key) -> (Int, String) in
                let newPage = pg + 1
                newPage >= 10 ? isEnd.accept(true) : isEnd.accept(false)
                page.accept(newPage)
                return (newPage, key)
            }
            .flatMapLatest {
                model.fetchImageInfo(page: $0, searchKey: $1)
            }
        
        let additionalCellData = additionalFetchedData
            .map { data -> [ImageInfo]? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value.imageInfos
            }
            .filterNil()
        
        let additionalErrorMessage = additionalFetchedData
            .map { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.message
            }
            .filterNil()
        
//        let additionalIsEnd = additionalFetchedData
//            .map{ data -> Bool? in
//                guard case .success(let value) = data else {
//                    return nil
//                }
//                return value.meta.isEnd
//            }
//            .filterNil()
        
        // Reduce Step
        additionalCellData
            .map { (data) -> [ImageInfo] in
                var newAcc = cellDataAccumulator.value
                newAcc.append(contentsOf: data)
                return newAcc
            }
            .do(onNext:{ cellDataAccumulator.accept($0) })
            .bind(to: cellDataProxy)
            .disposed(by: disposeBag)
        
        additionalErrorMessage
            .bind(to: errorMessageProxy)
            .disposed(by: disposeBag)
        
//        additionalIsEnd
//            .bind(to: isEnd)
//            .disposed(by: disposeBag)
        
        
        // MARK: - [Action 4]..< Notification Action >
        
        // Mutate & Reduce Step
        NotificationCenter.default.rx.notification(Notifications.removeFavorite)
            .mapToVoid()
            .bind(to: reloadListProxy)
            .disposed(by: disposeBag)
=======
            let modifiedFavoriteTab = NotificationCenter.default.rx.notification(Notifications.removeFavorite)
                .withLatestFrom(searchButtonTapped)
                
            return Observable.merge(
                      searchKeywordCleared,
                      searchButtonTapped,
                      modifiedFavoriteTab
                   )
                   .asDriver(onErrorJustReturn: [])
    }
    
    private func modifyFavorite(errorTracker: PublishRelay<String>) -> Signal<Int> {
        favoriteButtonSelected
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { document, index, action in
                PersistenceManager.updateWith(favorite: document, actionType: action)
                    .do(onNext: { error in
                        guard let error = error else { return }
                        errorTracker.accept(error.localizedDescription)
                    })
                    .filter { error in
                        error == nil
                    }
                    .map { _ in index }
                    .asSignal(onErrorSignalWith: .empty())
            }
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
    }
}
