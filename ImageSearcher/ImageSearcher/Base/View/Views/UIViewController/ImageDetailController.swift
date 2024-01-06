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
        navigationController?.navigationBar.isHidden = true
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(detailImageView)
        detailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.setImage(UIImage(systemName: Images.back,
                                    withConfiguration: UIImage.SymbolConfiguration(scale: .large))?
                                    .withTintColor(.green, renderingMode: .alwaysOriginal),
                                    for: .normal)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(30)
        }
    }
    
    private func bind() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
                self?.navigationController?.navigationBar.isHidden = false
            })
            .disposed(by: disposeBag)
    }
}
