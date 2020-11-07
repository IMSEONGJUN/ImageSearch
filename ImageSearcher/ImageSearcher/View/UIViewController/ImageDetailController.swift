//
//  ImageDetailController.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// This ViewController only has codes about UI.
// So, it is categorized as a 'View' even though it is a ViewController.
final class ImageDetailController: UIViewController {

    private var detailImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let backButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
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
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func setImage(_ image: UIImage?) {
        self.detailImageView.image = image
    }
}
