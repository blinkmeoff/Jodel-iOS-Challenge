//
//  FullScreenImageViewController.swift
//  JodelChallenge
//
//  Created by Igor on 03.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import UIKit
import SnapKit

class FullScreenImageViewController: UIViewController {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    init(image: UIImage?, tag: Int) {
        super.init(nibName: nil, bundle: nil)
        imageView.tag = tag
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        let aspectRatio = imageView.intrinsicContentSize.height / imageView.intrinsicContentSize.width
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(view.snp.width).multipliedBy(aspectRatio)
        }
        
    }
    
}
