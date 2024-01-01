//
//  ImageSearchResponse.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/1/24.
//

import Foundation

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
