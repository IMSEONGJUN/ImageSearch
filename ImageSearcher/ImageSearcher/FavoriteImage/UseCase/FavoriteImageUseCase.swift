//
//  FavoriteImageUseCase.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/1/24.
//

import Foundation
import RxSwift

protocol FavoriteImageUseCasable {
    func retrieveFavorites() -> Single<Result<Set<ImageInfo>, FavoriteError>>
    func updateWith(favorite: ImageInfo, updateType: PersistenceUpdateType) -> Single<FavoriteError?>
}

class FavoriteImageUseCase: FavoriteImageUseCasable {
    func retrieveFavorites() -> Single<Result<Set<ImageInfo>, FavoriteError>> {
        PersistenceManager.retrieveFavorites()
    }
    
    func updateWith(favorite: ImageInfo, updateType: PersistenceUpdateType) -> Single<FavoriteError?> {
        PersistenceManager.updateWith(favorite: favorite, updateType: updateType)
    }
}
