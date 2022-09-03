//
//  FeedCell.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

class FeedCell : TableViewCell {
    
    static let resuseId = String(describing: FeedCell.self)
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.kf.indicatorType = .activity
        view.snp.makeConstraints {
            $0.height.equalTo(180)
        }
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.numberOfLines = 0
        view.contentMode = .left
        view.textColor = .black
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    lazy var feedStackView: UIStackView = {
        let subviews: [UIView] = []
        let view = UIStackView(arrangedSubviews: [photoImageView, titleStackView])
        view.axis = .vertical
        view.spacing = 12
        return view
    }()
    
    lazy var titleStackView: UIStackView = {
        let subviews: [UIView] = []
        let view = UIStackView(arrangedSubviews: [titleLabel])
        view.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .leading
        return view
    }()
    
    override func setupUI() {
        super.setupUI()
        stackView.insertArrangedSubview(feedStackView, at: 0)
    }
    
    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? FeedCellViewModel else { return }
        
        viewModel.imageUrl.map { $0?.url }.asDriver(onErrorJustReturn: nil)
            .drive(photoImageView.rx.imageURL).disposed(by: cellDisposeBag)
        
        viewModel.title.asDriver().drive(titleLabel.rx.text).disposed(by: cellDisposeBag)
        photoImageView.tag = Int(viewModel.photo.id ?? "0") ?? 0
    }
}

extension String {
    var url: URL? {
        return URL(string: self)
    }
}
