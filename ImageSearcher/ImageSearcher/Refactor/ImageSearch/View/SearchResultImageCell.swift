//
//  SearchResultImageCell.swift
//  ImageSearcher
//
//  Created by SEONGJUN on 12/30/23.
//

import UIKit
import RxSwift

class SearchResultImageCell: UICollectionViewCell {
    
    let imageView = CellImageView(frame: .zero)
    private let favoriteButton = FavoriteButton()
    
    private var disposeBag = DisposeBag()
    
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, horizontalStackView])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, favoriteButton])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(verticalStackView)
        contentView.backgroundColor = .systemBackground
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
    }
    
    func setItem(item: ImageInfo, favoriteButtonTapSubject: PublishSubject<Void>) {
        disposeBag = DisposeBag()
        
    }
}
