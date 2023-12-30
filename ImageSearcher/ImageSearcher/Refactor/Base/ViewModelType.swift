//
//  ViewModelType.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import Foundation

protocol ViewModelable {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
