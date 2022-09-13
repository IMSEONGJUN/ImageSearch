//
//  ViewModelType.swift
//  SmoothyAssingment
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var input: Input! { get }
    var output: Output! { get }
}
