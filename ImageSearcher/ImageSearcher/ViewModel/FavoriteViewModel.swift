//
//  FavoriteViewModel.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear: AnyObserver<Void>
        let refreshPulled: AnyObserver<Void>
        let aTableViewRowDeleted: AnyObserver<Void>
    }
    
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
        
        let loadingCompletedRelay = PublishRelay<Bool>()
        let sharedFetchedData = fetchData(loadingCompleted: loadingCompletedRelay)
        
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
            .do(onNext: { _ in loadingCompleted.accept(true) })
            .asDriver(onErrorJustReturn: .failure(.failedToLoadFavorite))
    }
    
    private func dataSources(initialFetch: Driver<Result<[Document], FavoriteError>>) -> Driver<[Document]> {
        initialFetch
            .compactMap{ data -> [Document]? in
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
            .asSignal(onErrorJustReturn: "")
    }
}
