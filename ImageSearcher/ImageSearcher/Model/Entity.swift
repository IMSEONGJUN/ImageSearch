//
//  ImageInfo.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation


// MARK: - ImageInfo
struct ImageSearchResponse: Decodable, Hashable {
    let imageInfos: [ImageInfo]
    let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case imageinfos = "documents"
        case meta
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageInfos = try container.decode([ImageInfo].self, forKey: .imageinfos)
        meta = try container.decode(Meta.self, forKey: .meta)
    }
}

// MARK: - ImageInfo
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

// MARK: - Meta
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

struct ImageSearchResultSectionModel: SectionModeling {
    var section: ImageSearchResultSection
    var items: [ImageSearchResultItem]
}

enum ImageSearchResultSection {
    case main
}

enum ImageSearchResultItem: Hashable {
    case image(ImageInfo)
}
