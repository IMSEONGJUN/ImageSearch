//
//  FavoriteButton.swift
//  SmoothyAssingment
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit

final class FavoriteButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configire()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configire() {
        isEnabled = true
        setImage(UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?
                                        .withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        setImage(UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?
                                        .withTintColor(#colorLiteral(red: 0.9798753858, green: 0.8809804916, blue: 0.004552591592, alpha: 1), renderingMode: .alwaysOriginal), for: .selected)
        imageView?.contentMode = .scaleAspectFill
    }
    
}
