//
//  SectionModeling.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import Foundation

protocol SectionModeling<Section, Item>: Hashable {
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    
    var section: Section { get }
    var items: [Item] { get }
}
