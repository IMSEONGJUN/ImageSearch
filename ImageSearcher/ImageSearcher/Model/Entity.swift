//
//  ImageInfo.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation


// MARK: - ImageInfo
struct ImageSearchResponse: Codable, Hashable {
    let imageInfos: [ImageInfo]
    let meta: Meta
}

// MARK: - ImageInfo
struct ImageInfo: Codable, Hashable {
    let displaySitename: String
    let imageUrl: String
    
    static func ==(lhs: ImageInfo, rhs: ImageInfo) -> Bool {
        lhs.displaySitename == rhs.displaySitename && lhs.imageUrl == rhs.imageUrl
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(displaySitename)
        hasher.combine(imageUrl)
    }
}

// MARK: - Meta
struct Meta: Codable, Hashable {
    let isEnd: Bool
    
    static func ==(lhs: Meta, rhs: Meta) -> Bool {
        lhs.isEnd == rhs.isEnd
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(isEnd)
    }
}

struct ImageSearchResultSectionModel: SectionModeling {
    var section: ImageSearchResultSection
    var items: [ImageSearchResultItem]
}

enum ImageSearchResultSection {
    case main
}

enum ImageSearchResultItem: Hashable {
    case image(ImageSearchResponse)
}
