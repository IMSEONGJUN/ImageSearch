//
//  PersistenceDataManager.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: ImageInfo, actionType: PersistenceActionType) -> Observable<FavoriteError?>  {
        return retrieveFavorites()
            .map { favoritedData -> FavoriteError? in
                switch favoritedData {
                case .success(let favorites):
                    var retrievedFavorites = favorites
                    
                    switch actionType {
                    case .add:
                        guard !retrievedFavorites.contains(favorite) else {
                            return .alreadyInFavorites
                        }
                        retrievedFavorites.append(favorite)
                        
                    case .remove:
                        retrievedFavorites.removeAll {$0.imageUrl == favorite.imageUrl}
                    }
                    return save(favorites: retrievedFavorites)
                    
                case .failure(let error):
                    return error
                }
            }
    }

    static func checkIsFavorited(imageInfo: ImageInfo) -> Observable<Bool> {
        return retrieveFavorites()
            .map { favoritedData -> Bool in
                switch favoritedData {
                case .success(let favorites):
                    let retrievedFavorites = favorites
                    if retrievedFavorites.contains(imageInfo) {
                       return true
                    }
                case .failure(_):
                    return false
                }
                return false
            }
    }
    
    static func retrieveFavorites() -> Observable<Result<[ImageInfo], FavoriteError>> {
        guard let favoriteData = defaults.object(forKey: Keys.favorites) as? Data else {
            return .just(.success([]))
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([ImageInfo].self, from: favoriteData)
            return .just(.success(favorites))
        } catch {
            return .just(.failure(.failedToLoadFavorite))
        }
    }
    
    static func save(favorites: [ImageInfo]) -> FavoriteError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .failedToSaveFavorite
        }
    }
}
