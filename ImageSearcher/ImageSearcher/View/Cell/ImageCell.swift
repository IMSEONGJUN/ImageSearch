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
<<<<<<< HEAD
    var cellData: ImageInfo! {
        didSet{
            configureCell()
        }
    }
    
=======
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
    let imageView = CellImageView(frame: .zero)
    private let favoriteButton = FavoriteButton()
    var disposeBag = DisposeBag()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        imageView.image = nil
        favoriteButton.isSelected = false
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
    
    func configureCell(index: Int,
                       data: Document,
                       selectFavoriteButton: PublishSubject<(Document, Int, PersistenceActionType)>) {

        self.label.text = data.displaySitename
        ImageService.shared.downloadImage(from: data.imageUrl)
            .observe(on: MainScheduler.instance)
            .compactMap {
                guard case .success(let image) = $0 else { return nil }
                return image
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        PersistenceManager.checkIsFavorited(document: data)
            .bind(to: favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .scan(favoriteButton.isSelected) { prev, _ in
                return !prev
            }
            .map { isSelected -> PersistenceActionType in
                isSelected ? .add : .remove
            }
            .map { action in
                (data, index, action)
            }
<<<<<<< HEAD
            .subscribe(onNext: { action, error in
                if let error = error?.rawValue {
                    print(error)
                    return
                }
                switch action {
                case .add:
                    print("즐겨찾기에 추가완료")
                case .remove:
                    print("즐겨찾기에서 삭제완료")
                    NotificationCenter.default.post(name: Notifications.removeFavorite, object: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureCell() {
        self.label.text = cellData.displaySitename
        ImageService.shared.downloadImage(from: cellData.imageUrl)
            .drive(onNext: { [weak self] in
                guard case .success(let image) = $0 else { return }
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
        
        PersistenceManager.checkIsFavorited(imageInfo: cellData)
            .subscribe(onNext: { [weak self] in
                self?.favoriteButton.isSelected = $0
            })
=======
            .bind(to: selectFavoriteButton)
>>>>>>> 57d7c16652fab14a375e20a30696fbd01d65ad7a
            .disposed(by: disposeBag)
    }
}
