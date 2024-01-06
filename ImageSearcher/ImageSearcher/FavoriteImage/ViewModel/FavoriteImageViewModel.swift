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
        let dataSource: Driver<Result<Set<ImageInfo>, FavoriteError>>
        let unmarkDone: Driver<FavoriteError?>
    }
    
    private let useCase: any FavoriteImageUseCasable
    
    init(useCase: some FavoriteImageUseCasable) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let useCase = self.useCase
        
        let dataSource = useCase.favoriteUpdated()
            .startWith(())
            .flatMapLatest {
                useCase.retrieveFavorites()
                    .asObservable()
            }
            .asDriver(onErrorJustReturn: .failure(.failedToLoadFavorite))
        
        let unmarkDone = input.unmarkFavorite
            .flatMapLatest { imageInfo in
                useCase.updateWith(favorite: imageInfo, updateType: .remove)
            }
            .asDriver(onErrorJustReturn: .failedToRemoveFavorite)
        
        return Output(dataSource: dataSource, unmarkDone: unmarkDone)
    }
}
