//
//  ImageSearchAPI.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import Foundation
import Moya

enum ImageSearchAPI {
    struct KakaoImageSearchComponents {
        static let scheme = "https"
        static let host = "dapi.kakao.com"
        static let path = "/v2/search/image"
        static let apiKey = "KakaoAK 60999a577f9a0d8e4ed3225bb27c941b"
    }
    
    case search(keyword: String, page: Int?)
}

extension ImageSearchAPI: TargetType {
    var baseURL: URL {
        var components = URLComponents()
        components.scheme = KakaoImageSearchComponents.scheme
        components.host = KakaoImageSearchComponents.host
        return components.url!
    }
    
    var path: String {
        KakaoImageSearchComponents.path
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .search(keyword, page):
            var params: [String: Any] = [
                "query": keyword,
                "size": "20"
            ]
            
            if let page {
                params.updateValue(page, forKey: "page")
            }
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        [
            "Authorization": KakaoImageSearchComponents.apiKey,
            "Content-Type": "application/json"
        ]
    }
    
    var sampleData: Data {
        stubbedData(filename: "imageSearchResultStub")
    }
}
