//
//  ImageSearchCoordinator.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/31/23.
//

import UIKit

final class ImageSearchCoordinator: BaseCoordinator {
    override func start() -> UIViewController {
        let imageSearchUseCase = ImageSearchUseCase()
        let viewModel = ImageSearchViewModel(useCase: imageSearchUseCase)
        let viewController = ImageSearchViewController(viewModel: viewModel, coordinator: self)
        viewController.configureNavigationBar(with: NavigationBarTitle.imageSearchList, prefersLargeTitles: false)
        let navigationController = viewController.wrapNavigationController()
        registerBaseViewController(viewController)
        return navigationController
    }
    
    func showDetailImageViewController(imageUrlString: String) {
        let viewController = ImageDetailController(urlString: imageUrlString)
        baseViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
