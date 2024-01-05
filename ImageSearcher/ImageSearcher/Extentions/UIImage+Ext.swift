//
//  UIImage+Ext.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 1/5/24.
//

import UIKit

extension UIImage {
    func resize(_ size: CGSize, ignoreDeviceScale: Bool = false) -> UIImage {
        let scale: CGFloat = ignoreDeviceScale ? 1 : UIScreen.main.scale
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
