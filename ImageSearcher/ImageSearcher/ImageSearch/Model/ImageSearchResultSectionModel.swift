//
//  ImageSearchResultSectionModel.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/1/24.
//

import Foundation

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
