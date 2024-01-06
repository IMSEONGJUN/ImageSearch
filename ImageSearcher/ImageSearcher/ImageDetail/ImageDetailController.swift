//
//  ImageDetailController.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ImageDetailController: UIViewController {

    private var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let backButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    init(urlString: String) {
        let url = URL(string: urlString)
        self.detailImageView.sd_setImage(with: url)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(detailImageView)
        detailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
