//
//  FavoriteImageViewModel.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteImageViewModel: ViewModelType {
    struct Input {
        let unmarkFavorite: Observable<ImageInfo>
    }
    
    struct Output {
        let dataSource: Driver<Result<[ImageInfo], FavoriteError>>
        let unmarkDone: Driver<FavoriteError?>
    }
    
    func transform(_ input: Input) -> Output {
        let dataSource = PersistenceManager.dataUpdated
            .startWith(())
            .flatMapLatest {
                PersistenceManager.retrieveFavoritesArray()
                    .asObservable()
            }
            .asDriver(onErrorJustReturn: .failure(.failedToLoadFavorite))
        
        let unmarkDone = input.unmarkFavorite
            .flatMapLatest { imageInfo in
                PersistenceManager.updateWith(favorite: imageInfo, actionType: .remove)
            }
            .asDriver(onErrorJustReturn: .failedToRemoveFavorite)
        
        return Output(dataSource: dataSource, unmarkDone: unmarkDone)
    }
}
