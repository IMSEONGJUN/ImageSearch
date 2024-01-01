//
//  ImageService.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageService {
    static let shared = ImageService()
    
    private init(){}
    let session = URLSession.shared
    let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(from urlString: String) -> Observable<Result<UIImage,ImageLoadError>> {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            return .just(.success(image))
        }
        guard let url = URL(string: urlString) else {
            return .just(.failure(.invalidUrl))
        }
        
        return session.rx.data(request: URLRequest(url: url))
            .map { data in
                guard let image = UIImage(data: data) else {
                    return .failure(.invaildData)
                }
                self.cache.setObject(image, forKey: cacheKey)
                
                return .success(image)
            }
            .catch { error in
                return .just(.failure(.unableToComplete))
            }
    }
}

