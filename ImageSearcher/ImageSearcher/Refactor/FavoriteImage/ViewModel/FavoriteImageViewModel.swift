//
//  FavoriteImageViewModel.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteImageViewModel: ViewModelable {
    struct Input {
        let unmarkFavorite: Observable<ImageInfo>
    }
    
    struct Output {
        let dataSource: Driver<[ImageInfo]>
        let unmarkDone: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let dataSource = PersistenceManager.dataUpdated
            .startWith(())
            .flatMapLatest {
                PersistenceManager.retrieveFavoritesArray()
                    .compactMap { result -> [ImageInfo]? in
                        if case let .success(imageInfos) = result {
                            return imageInfos
                        }
                        return nil
                    }
                    .asObservable()
            }
            .asDriver(onErrorJustReturn: [])
        
        let unmarkDone = input.unmarkFavorite
            .flatMapLatest { imageInfo in
                PersistenceManager.updateWith(favorite: imageInfo, actionType: .remove)
                    .map { _ in }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(dataSource: dataSource, unmarkDone: unmarkDone)
    }
}
