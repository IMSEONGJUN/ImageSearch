//
//  FavoriteViewModel.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa

struct FavoriteViewModel: FavoriteViewModelBindable {
    // Action with Void
    let viewWillAppear = PublishRelay<Void>()
    let refreshPulled = PublishRelay<Void>()
    let aTableViewRowDeleted = PublishRelay<Void>()
    
    // State
    let cellData: Driver<[ImageInfo]>
    let errorMessage: Signal<String>
    let loadingCompleted: Driver<Bool>
    
    let disposeBag = DisposeBag()
    
    init() {
        
        // Proxy
        let cellDataProxy = PublishRelay<[ImageInfo]>()
        cellData = cellDataProxy.asDriver(onErrorJustReturn: [])
        
        let errorMessageProxy = PublishRelay<String>()
        errorMessage = errorMessageProxy.asSignal()
        
        let loadingCompletedProxy = PublishRelay<Bool>()
        loadingCompleted = loadingCompletedProxy.asDriver(onErrorJustReturn: false)
        
        
        // MARK: Data Processing Step: [ Action check -> Mutate -> reduce State ]
        
        // MARK: - [Action 1]..< ViewWillAppear Action >
        
        // Mutate Step
        let initiailFetch = viewWillAppear
            .flatMapLatest(PersistenceManager.retrieveFavorites)
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
                guard case .success(let value) = data else {
                    return nil
                }
                return value.reversed()
            }
            .bind(to: cellDataProxy)
            .disposed(by: disposeBag)
        
        refreshedData
            .compactMap { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.rawValue
            }
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
    }
}
