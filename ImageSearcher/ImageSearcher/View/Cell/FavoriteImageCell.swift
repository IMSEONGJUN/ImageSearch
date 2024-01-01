//
//  FavoriteImageCell.swift
//
//  Created by SEONGJUN on 2020/10/09.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteImageCell: UITableViewCell {
    let favoriteImageView = CellImageView(frame: .zero)
    let favoriteButton = FavoriteButton()
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        backgroundColor = .systemBackground
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteImageView.image = nil
        favoriteButton.isSelected = false
        disposeBag = DisposeBag()
    }
    
    private func configureUI() {
        contentView.addSubview(favoriteImageView)
        contentView.addSubview(favoriteButton)
        accessoryType = .disclosureIndicator
        
        favoriteImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(favoriteImageView.snp.height).multipliedBy(0.7)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(favoriteImageView.snp.trailing).offset(100)
        }
    }
    
    func configureCell(item: ImageInfo, unmarkFavoriteSubject: PublishSubject<ImageInfo>) {
        let url = URL(string: item.imageUrl)
        favoriteImageView.sd_setImage(with: url)
        self.favoriteButton.isSelected = true
        favoriteButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map { item }
            .bind(to: unmarkFavoriteSubject)
            .disposed(by: disposeBag)
    }
}

