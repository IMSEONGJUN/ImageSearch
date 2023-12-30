//
//  Coordinator.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit

protocol Coordinator {
    var baseViewController: UIViewController? { get }
    func start() -> UIViewController
}
