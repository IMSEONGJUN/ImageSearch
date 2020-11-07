//
//  FavoriteImageCell.swift
//
//  Created by SEONGJUN on 2020/10/09.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteImageCell: UITableViewCell {
    
    var cellData: Document! {
        didSet {
            configureCellData()
        }
    }
    
    let favoriteImageView = CellImageView(frame: .zero)
    let favoriteButton = FavoriteButton()
    
    let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        backgroundColor = .systemBackground
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func bind() {
        favoriteButton.rx.tap
            .bind(to: self.rx.removeFavoritedData)
            .disposed(by: disposeBag)
    }
    
    private func configureCellData() {
        let url = URL(string: cellData.imageUrl)
        favoriteImageView.sd_setImage(with: url)
        self.favoriteButton.isSelected = true
    }
}

