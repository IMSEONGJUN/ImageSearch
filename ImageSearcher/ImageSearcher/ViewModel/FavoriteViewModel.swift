//
//  FavoriteViewModel.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteViewModel: ViewModelType {
    
<<<<<<< HEAD
    // State
    let cellData: Driver<[ImageInfo]>
    let errorMessage: Signal<String>
    let loadingCompleted: Driver<Bool>
=======
    struct Input {
        let viewWillAppear: AnyObserver<Void>
        let refreshPulled: AnyObserver<Void>
        let aTableViewRowDeleted: AnyObserver<Void>
    }
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
    
    struct Output {
        let cellData: Driver<[Document]>
        let errorMessage: Signal<String>
        let loadingCompleted: Signal<Bool>
    }
    
    private(set) var input: Input!
    private(set) var output: Output!
     
    private let viewWillAppearSubject = PublishSubject<Void>()
    private let refreshPulledSubject = PublishSubject<Void>()
    private let aTableViewRowDeletedSubject = PublishSubject<Void>()
    
    init() {
        input = Input(viewWillAppear: viewWillAppearSubject.asObserver(),
                      refreshPulled: refreshPulledSubject.asObserver(),
                      aTableViewRowDeleted: aTableViewRowDeletedSubject.asObserver())
        
<<<<<<< HEAD
        // Proxy
        let cellDataProxy = PublishRelay<[ImageInfo]>()
        cellData = cellDataProxy.asDriver(onErrorJustReturn: [])
=======
        let loadingCompletedRelay = PublishRelay<Bool>()
        let sharedFetchedData = fetchData(loadingCompleted: loadingCompletedRelay)
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
        
        output = Output(cellData: dataSources(initialFetch: sharedFetchedData),
                        errorMessage: errorMessage(initialFetch: sharedFetchedData),
                        loadingCompleted: loadingCompletedRelay.asSignal(onErrorJustReturn: false))
    }
    
    private func fetchData(loadingCompleted: PublishRelay<Bool>) -> Driver<Result<[Document], FavoriteError>> {
        Observable.merge(
                viewWillAppearSubject,
                refreshPulledSubject,
                NotificationCenter.default.rx.notification(Notifications.removeFavorite).mapToVoid()
            )
            .flatMapLatest(PersistenceManager.retrieveFavorites)
<<<<<<< HEAD
            .share()
        
        let favoriteList = initiailFetch
            .map { data -> [ImageInfo]? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
            .filterNil()
        
        let favoriteError = initiailFetch
            .map { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.rawValue
            }
            .filterNil()
        
        // Reduce Step
        favoriteList
            .map{ $0.reversed() }
            .bind(to: cellDataProxy)
            .disposed(by: disposeBag)
        
        favoriteError
            .bind(to: errorMessageProxy)
            .disposed(by: disposeBag)
        
        
        // MARK: - [Action 2]..< RefreshPulled Action >
        
        // Mutate Step
        let refreshedData = refreshPulled
            .flatMapLatest(PersistenceManager.retrieveFavorites)
            .share()
        
        refreshedData
            .map { _ in true }
            .bind(to: loadingCompletedProxy)
            .disposed(by: disposeBag)
        
        // Reduce Step
        refreshedData
            .compactMap { data -> [ImageInfo]? in
=======
            .do(onNext: { _ in loadingCompleted.accept(true) })
            .asDriver(onErrorJustReturn: .failure(.failedToLoadFavorite))
    }
    
    private func dataSources(initialFetch: Driver<Result<[Document], FavoriteError>>) -> Driver<[Document]> {
        initialFetch
            .compactMap{ data -> [Document]? in
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
                guard case .success(let value) = data else {
                    return nil
                }
                return value.reversed()
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    private func errorMessage(initialFetch: Driver<Result<[Document], FavoriteError>>) -> Signal<String> {
        initialFetch
            .compactMap { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.rawValue
            }
<<<<<<< HEAD
            .bind(to: errorMessageProxy)
            .disposed(by: disposeBag)
        
        
        // MARK: - [Action 3]..< Notification Action >
        
        // Mutate & Reduce Step
        NotificationCenter.default.rx.notification(Notifications.removeFavorite)
            .mapToVoid()
            .flatMapLatest(PersistenceManager.retrieveFavorites)
            .compactMap { data -> [ImageInfo]? in
                guard case .success(let value) = data else {
                    return nil
                }
                return value.reversed()
            }
            .bind(to: cellDataProxy)
            .disposed(by: disposeBag)
=======
            .asSignal(onErrorJustReturn: "")
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
    }
}
