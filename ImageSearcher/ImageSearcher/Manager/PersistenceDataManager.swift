//
//  PersistenceDataManager.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa

enum PersistenceUpdateType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    static private var cache = Set<ImageInfo>()
    
    static private var cachedArray: [ImageInfo] {
        Array(cache)
    }
    
    static let dataUpdated = PublishSubject<Void>()
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: ImageInfo, updateType: PersistenceUpdateType) -> Single<FavoriteError?>  {
        return retrieveFavorites()
            .map { favoritedData -> FavoriteError? in
                switch favoritedData {
                case .success(let favorites):
                    switch updateType {
                    case .add:
                        guard !favorites.contains(favorite) else {
                            return .alreadyInFavorites
                        }
                        
                        cache.insert(favorite)
                        
                    case .remove:
                        cache.remove(favorite)
                    }
                    
                    do {
                        try update()
                    } catch {
                        return FavoriteError.failedToSaveFavorite
                    }
                    
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
    
    static func retrieveFavorites() -> Single<Result<Set<ImageInfo>, FavoriteError>> {
        guard cache.isEmpty else {
            return .just(.success(cache))
        }
        
        guard let favoriteData = defaults.object(forKey: Keys.favorites) as? Data else {
            return .just(.success([]))
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode(Set<ImageInfo>.self, from: favoriteData)
            cache = cache.union(favorites)
            return .just(.success(favorites))
        } catch {
            return .just(.failure(.failedToLoadFavorite))
        }
    }
    
    static func update() throws {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(cache)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            dataUpdated.onNext(())
        } catch {
            throw error
        }
    }
}
