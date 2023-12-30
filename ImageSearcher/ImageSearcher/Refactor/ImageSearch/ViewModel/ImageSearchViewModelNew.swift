//
//  ImageSearchViewModel.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import Foundation

class ImageSearchViewModelNew: ViewModelable {
    struct Input {
        
    }
    
    struct Output {
        
    }
    private let useCase: any ImageSearchUseCasable
    
    init(useCase: some ImageSearchUseCasable) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        Output()
    }
}
