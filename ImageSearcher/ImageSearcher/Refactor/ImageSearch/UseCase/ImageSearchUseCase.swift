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
    associatedtype Target: TargetType
    
    var moyaProvider: MoyaProvider<Target> { get }
    func search(keyword: String, page: Int?) -> Single<ImageSearchResponse>
}

final class ImageSearchUseCase: ImageSearchUseCasable {
    let moyaProvider = MoyaProvider<ImageSearchAPI>()
    
    func search(keyword: String, page: Int?) -> Single<ImageSearchResponse> {
        moyaProvider.rx.request(ImageSearchAPI.search(keyword: keyword, page: page))
            .filterSuccessfulStatusCodes()
            .map(ImageSearchResponse.self)
    }
}


final class ImageSearchUseCaseMock {
    let moyaProvider = MoyaProvider<ImageSearchAPI>(stubClosure: MoyaProvider.immediatelyStub)
    
    func search(keyword: String, page: Int?) -> Single<ImageSearchResponse> {
        moyaProvider.rx.request(ImageSearchAPI.search(keyword: keyword, page: page))
            .filterSuccessfulStatusCodes()
            .map(ImageSearchResponse.self)
    }
}
