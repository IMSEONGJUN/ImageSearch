//
//  ImageSearchModel.swift
//  SmoothyAssingment
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import RxSwift

struct ImageSearchModel {
    let network: APIManager
    
    init(networkManager: APIManager = APIManager()) {
        self.network = networkManager
    }
    
    func fetchImageInfo(page: Int?, searchKey: String) -> Observable<Result<ImageInfo, NetworkError>> {
        return network.fetchImageInformation(page: page, searchKey: searchKey)
    }
}
