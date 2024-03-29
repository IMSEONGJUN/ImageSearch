//
//  ImageSearchUseCaseProvider.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import Foundation
import Moya
import RxSwift

protocol ImageSearchUseCasable {
    func search(keyword: String, page: Int?) -> Single<ImageSearchResponse>
    func updateFavorite(imageInfo: ImageInfo, actionType: PersistenceUpdateType) -> Single<FavoriteError?>
}

final class ImageSearchUseCase: ImageSearchUseCasable {
    let moyaProvider = MoyaProvider<ImageSearchAPI>()
    
    func search(keyword: String, page: Int?) -> Single<ImageSearchResponse> {
        return moyaProvider.rx.request(ImageSearchAPI.search(keyword: keyword, page: page))
            .filterSuccessfulStatusCodes()
            .do(onSuccess: { response in
                let dict = try response.mapJSON() as? [String: Any]
                print(dict)
            })
            .map(ImageSearchResponse.self)
    }
    
    func updateFavorite(imageInfo: ImageInfo, actionType: PersistenceUpdateType) -> Single<FavoriteError?> {
        PersistenceManager.updateWith(favorite: imageInfo, updateType: actionType)
    }
}
