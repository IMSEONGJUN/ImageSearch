//
//  ImageSearchUseCaseMock.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/31/23.
//
@testable import ImageSearcher
import RxSwift
import Moya

final class ImageSearchUseCaseMock {
    let moyaProvider = MoyaProvider<ImageSearchAPI>(stubClosure: MoyaProvider.immediatelyStub)
    
    func search(keyword: String, page: Int?) -> Single<ImageSearchResponse> {
        moyaProvider.rx.request(ImageSearchAPI.search(keyword: keyword, page: page))
            .filterSuccessfulStatusCodes()
            .map(ImageSearchResponse.self)
    }
    
    func markFavorite(imageInfo: ImageInfo) -> Single<FavoriteError?> {
        PersistenceManagerMock.updateWith(favorite: imageInfo, updateType: .add)
    }
}
