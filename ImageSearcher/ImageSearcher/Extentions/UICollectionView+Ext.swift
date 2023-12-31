//
//  UICollectionView.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/31/23.
//

import UIKit

extension UICollectionView {
    func registerCellClass(cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: "\(cellType)")
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type = T.self, indexPath: IndexPath, withReuseIdentifier: String? = nil) -> T {
        return dequeueReusableCell(withReuseIdentifier: withReuseIdentifier ?? "\(cellType)", for: indexPath) as! T
    }
}
