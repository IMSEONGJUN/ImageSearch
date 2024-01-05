//
//  ImageInfo.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/1/24.
//

import Foundation

struct ImageInfo: Codable, Hashable {
    let displaySitename: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case displaySitename = "display_sitename"
        case imageUrl = "image_url"
    }
    
    static func ==(lhs: ImageInfo, rhs: ImageInfo) -> Bool {
        lhs.displaySitename == rhs.displaySitename && lhs.imageUrl == rhs.imageUrl
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(displaySitename)
        hasher.combine(imageUrl)
    }
}

struct Meta: Codable, Hashable {
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
    }
    
    static func ==(lhs: Meta, rhs: Meta) -> Bool {
        lhs.isEnd == rhs.isEnd
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(isEnd)
    }
}
