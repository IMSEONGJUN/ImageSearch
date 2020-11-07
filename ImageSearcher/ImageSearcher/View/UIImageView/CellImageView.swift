//
//  SearchCellImageView.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit

final class CellImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentMode = .scaleAspectFill
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
