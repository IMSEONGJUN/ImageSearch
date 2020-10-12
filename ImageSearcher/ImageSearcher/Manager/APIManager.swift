//
//  NetworkManager.swift
//  SmoothyAssingment
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import RxSwift
import RxCocoa

final class APIManager {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchImageInformation(page: Int?, searchKey: String) -> Observable<Result<ImageInfo, NetworkError>> {
        guard let url = makeComponents(page: page, searchKey: searchKey).url else {
            let error = NetworkError.error("유효하지 않은 URL")
            return .just(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(KakaoImageSearchAPI.apiKey, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return session.rx.data(request: urlRequest)
            .map { data in
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let imageInfo = try decoder.decode(ImageInfo.self, from: data)
                    return .success(imageInfo)
                } catch {
                    return .failure(.error("데이터 디코딩 에러"))
                }
            }
    }
}

private extension APIManager {
    struct KakaoImageSearchAPI {
        static let scheme = "https"
        static let host = "dapi.kakao.com"
        static let path = "/v2/search/image"
        static let apiKey = "KakaoAK 60999a577f9a0d8e4ed3225bb27c941b"
    }
    
    func makeComponents(page: Int?, searchKey: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = KakaoImageSearchAPI.scheme
        components.host = KakaoImageSearchAPI.host
        components.path = KakaoImageSearchAPI.path
        if let page = page {
            components.queryItems = [
                URLQueryItem(name: "query", value: "\(searchKey)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "10")
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "query", value: "\(searchKey)"),
                URLQueryItem(name: "per_page", value: "10")
            ]
        }
        
        return components
    }
}
