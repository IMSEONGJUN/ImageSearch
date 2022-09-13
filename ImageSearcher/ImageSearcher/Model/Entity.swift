//
//  ImageInfo.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation


// MARK: - ImageInfo
struct ImageInfo: Codable {
    let documents: [Document]
    let meta: Meta
}

// MARK: - Document
struct Document: Codable, Equatable {
    let displaySitename: String
    let imageUrl: String
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
}
