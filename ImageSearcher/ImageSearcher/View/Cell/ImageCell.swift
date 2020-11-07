//
//  ImageCell.swift
//
//  Created by SEONGJUN on 2020/10/08.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import RxCocoa
import RxSwift

final class ImageCell: UICollectionViewCell {
    var cellData: Document! {
        didSet{
            configureCell()
        }
    }
    
    let imageView = CellImageView(frame: .zero)
    private let favoriteButton = FavoriteButton()
    
    let disposeBag = DisposeBag()
    
    private lazy var verticalStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [imageView, horizontalStackView])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var horizontalStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [label, favoriteButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private let label: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(verticalStackView)
        
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        verticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
    
    @objc func didTapFavoriteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            PersistenceManager.updateWith(favorite: cellData, actionType: .add)
                .map{ $0?.rawValue }
                .subscribe(onNext: {
                    if let error = $0 {
                        print(error)
                        return
                    }
                    print("즐겨찾기에 추가완료")
                })
                .disposed(by: disposeBag)
        } else {
            PersistenceManager.updateWith(favorite: cellData, actionType: .remove)
                .map{ $0?.rawValue }
                .subscribe(onNext: {
                    if let error = $0 {
                        print(error)
                        return
                    }
                    print("즐겨찾기에서 삭제완료")
                    NotificationCenter.default.post(name: Notifications.removeFavorite, object: nil)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func configureCell() {
        self.label.text = cellData.displaySitename
        ImageService.shared.downloadImage(from: cellData.imageUrl)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard case .success(let image) = $0 else { return }
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
        
        PersistenceManager.checkIsFavorited(document: cellData)
            .subscribe(onNext: { [weak self] in
                self?.favoriteButton.isSelected = $0
            })
            .disposed(by: disposeBag)
    }
}
