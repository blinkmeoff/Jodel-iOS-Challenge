//
//  FullScreenPresentationController.swift
//  JodelChallenge
//
//  Created by Igor on 03.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import UIKit
import SnapKit

class FullScreenPresentationController: UIPresentationController {
    private lazy var closeButtonContainer: UIVisualEffectView = {
        let closeButtonBlurEffectView = UIVisualEffectView(effect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(close), for: .primaryActionTriggered)
        
        closeButtonBlurEffectView.contentView.addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        vibrancyEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButtonBlurEffectView.layer.cornerRadius = 24
        closeButtonBlurEffectView.clipsToBounds = true
        closeButtonBlurEffectView.snp.makeConstraints {
            $0.size.equalTo(48)
        }
        return closeButtonBlurEffectView
    }()
    
    private lazy var backgroundView: UIVisualEffectView = {
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.effect = nil
        return blurVisualEffectView
    }()
    
    private let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
    
    @objc private func close(_ button: UIButton) {
        presentedViewController.dismiss(animated: true)
    }
}

extension FullScreenPresentationController {
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        containerView.addSubview(backgroundView)
        containerView.addSubview(closeButtonContainer)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButtonContainer.snp.makeConstraints {
            $0.top.equalTo(containerView.safeAreaLayoutGuide.snp.top).offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
                
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else { return }
        
        closeButtonContainer.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        transitionCoordinator.animate(alongsideTransition: { context in
            self.backgroundView.effect = self.blurEffect
            self.closeButtonContainer.transform = .identity
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            backgroundView.removeFromSuperview()
            closeButtonContainer.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else { return }
        
        transitionCoordinator.animate(alongsideTransition: { context in
            self.backgroundView.effect = nil
            self.closeButtonContainer.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            backgroundView.removeFromSuperview()
            closeButtonContainer.removeFromSuperview()
        }
    }
}
