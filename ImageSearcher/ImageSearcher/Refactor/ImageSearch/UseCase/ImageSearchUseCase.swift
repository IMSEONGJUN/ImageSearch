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
    func markFavorite(imageInfo: ImageInfo) -> Single<FavoriteError?>
}

final class ImageSearchUseCase: ImageSearchUseCasable {
    let moyaProvider = MoyaProvider<ImageSearchAPI>()
    
    func search(keyword: String, page: Int?) -> Single<ImageSearchResponse> {
        return moyaProvider.rx.request(ImageSearchAPI.search(keyword: keyword, page: page))
            .filterSuccessfulStatusCodes()
            .map(ImageSearchResponse.self)
            .catch { error in
                print("@@@api error:", error)
                throw error
            }
    }
    
    func markFavorite(imageInfo: ImageInfo) -> Single<FavoriteError?> {
        PersistenceManager.updateWith(favorite: imageInfo, actionType: .add)
    }
}
