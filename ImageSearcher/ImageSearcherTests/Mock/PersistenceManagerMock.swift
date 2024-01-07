//
//  PersistenceDataManagerMock.swift
//  ImageSearcherTests
//
//  Created by SEONGJUN on 1/6/24.
//
@testable import ImageSearcher
import Foundation
import RxSwift

enum PersistenceManagerMock {
    static private var defaults = [String: Any]()
    
    static let dataUpdated = PublishSubject<Void>()
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: ImageInfo, updateType: PersistenceUpdateType) -> Single<FavoriteError?>  {
        return retrieveFavorites()
            .map { favoritedData -> FavoriteError? in
                switch favoritedData {
                case .success(let favorites):
                    var mutableFavorites = favorites
                    
                    switch updateType {
                    case .add:
                        guard !favorites.contains(favorite) else {
                            return .alreadyInFavorites
                        }
                        mutableFavorites.append(favorite)
                        
                    case .remove:
                        mutableFavorites.removeAll(where: { $0 == favorite })
                    }
                    
                    defaults[Keys.favorites] = mutableFavorites
                    dataUpdated.onNext(())
                    return nil
                    
                case .failure(let error):
                    return error
                }
            }
    }

    static func checkIsFavorited(imageInfo: ImageInfo) -> Single<Bool> {
        return retrieveFavorites()
            .map { favoritedData -> Bool in
                switch favoritedData {
                case .success(let favorites):
                    if favorites.contains(imageInfo) {
                       return true
                    }
                case .failure(_):
                    return false
                }
                return false
            }
    }
    
    static func retrieveFavorites() -> Single<Result<[ImageInfo], FavoriteError>> {
        guard let favorites = defaults[Keys.favorites] as? [ImageInfo] else {
            return .just(.failure(.failedToLoadFavorite))
        }
        return .just(.success(favorites))
    }
}
