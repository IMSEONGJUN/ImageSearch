//
//  UIHelper.swift
//  SmoothyAssingment
//
//  Created by SEONGJUN on 2020/10/09.
//

import UIKit

struct UIHelper {
    
    static func twoColumnLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let collectionViewWidth = view.frame.width
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let itemsInLine: CGFloat = 2
        let itemSpacing: CGFloat = 0
        let lineSpacing: CGFloat = 0
        let availableWidth = collectionViewWidth - ((itemSpacing * (itemsInLine - 1)) + (inset.left + inset.right))
        let itemWidth = availableWidth / itemsInLine
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.sectionInset = inset
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + (itemWidth / 2))
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
}
