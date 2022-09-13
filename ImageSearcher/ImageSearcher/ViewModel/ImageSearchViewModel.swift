//
//  ImageSearchViewModel.swift
//  SmoothyAssingment
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
        let didFinishFavoriteAction: Signal<(FavoriteError?, Int)>
        let errorMessage: Signal<String>
    }
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let searchKeywordSubject = PublishSubject<String>()
    private let favoriteButtonSelected = PublishSubject<(Document, Int, PersistenceActionType)>()
    private let didScrollToBottomSubject = PublishSubject<Void>()
    private let searchButtonTappedSubject = PublishSubject<Void>()
    
    init() {
        input = Input(searchKeyword: searchKeywordSubject.asObserver(),
                      favoriteButtonSelected: favoriteButtonSelected.asObserver(),
                      didScrollToBottom: didScrollToBottomSubject.asObserver(),
                      searchButtonTapped: searchButtonTappedSubject.asObserver())
        
        
        let errorMessage = PublishRelay<String>()
        
        output = Output(dataSources: dataSourceOutput(errorTracker: errorMessage),
                        didFinishFavoriteAction: modifyFavorite(errorTracker: errorMessage),
                        errorMessage: errorMessage.asSignal())
    }
    
    private func dataSourceOutput(errorTracker: PublishRelay<String>) -> Driver<[Document]> {
        let isEnd = BehaviorRelay<Bool>(value: false)
        let page = BehaviorRelay<Int>(value: 1)
        
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
            }
            .scan([]) { prev, new in
                new.isEmpty ? [] : prev + new
            }
            .do(onNext: { _ in
                let newpage = page.value + 1
                page.accept(newpage)
            })
        
            let modifiedFavoriteTab = NotificationCenter.default.rx.notification(Notifications.removeFavorite)
                .withLatestFrom(searchButtonTapped)
                
            return Observable.merge(
                      searchKeywordCleared,
                      searchButtonTapped,
                      modifiedFavoriteTab
                   )
                   .asDriver(onErrorJustReturn: [])
    }
    
    private func modifyFavorite(errorTracker: PublishRelay<String>) -> Signal<(FavoriteError?, Int)> {
        favoriteButtonSelected
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { document, index, action in
                PersistenceManager.updateWith(favorite: document, actionType: action)
                    .map { error in (error, index) }
                    .do(onNext: { error, _ in
                        guard let error = error else { return }
                        errorTracker.accept(error.localizedDescription)
                    })
                    .asSignal(onErrorSignalWith: .empty())
            }
    }
}
