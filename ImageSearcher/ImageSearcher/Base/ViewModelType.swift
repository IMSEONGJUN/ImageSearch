//
//  ViewModelType.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
