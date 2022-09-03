//
//  TableViewCell.swift
//  JodelChallenge
//
//  Created by Igor on 02.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TableViewCell: UITableViewCell {

    var cellDisposeBag = DisposeBag()

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true

        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(8)
        })
        return view
    }()

    lazy var stackView: UIStackView = {
        let subviews: [UIView] = []
        let view = UIStackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.alignment = .center
        self.containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        })
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    func setupUI() {
        layer.masksToBounds = true
        selectionStyle = .none
        backgroundColor = .clear

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func bind(to viewModel: TableViewCellViewModel) {

    }
}
