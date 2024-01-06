//
//  TargetType+Ext.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/7/24.
//

import Moya

extension TargetType {
    func stubbedData(filename: String) -> Data! {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            return Data()
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}
