//
//  FavoriteImageUseCaseMock.swift
//  ImageSearcherTests
//
//  Created by SEONGJUN on 1/7/24.
//

@testable import ImageSearcher
import RxSwift
import Foundation

class FavoriteImageUseCaseMock: FavoriteImageUseCasable {
    func favoriteUpdated() -> RxSwift.Observable<Void> {
        PersistenceManagerMock.dataUpdated
    }
    
    func retrieveFavorites() -> Single<Result<Set<ImageInfo>, FavoriteError>> {
        PersistenceManagerMock.retrieveFavorites()
    }
    
    func updateWith(favorite: ImageInfo, updateType: PersistenceUpdateType) -> Single<FavoriteError?> {
        PersistenceManagerMock.updateWith(favorite: favorite, updateType: updateType)
    }
}
