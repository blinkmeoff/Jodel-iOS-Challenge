//
//  FullScreenAnimationController.swift
//  JodelChallenge
//
//  Created by Igor on 03.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation
import UIKit

class FullScreenAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    enum AnimationType {
        case present
        case dismiss
    }
    
    private let animationType: AnimationType
    private let animationDuration: TimeInterval
    private weak var anchorView: UIView?
    
    private let anchorViewCenter: CGPoint
    private let anchorViewSize: CGSize
    private let anchorViewTag: Int
    
    private var propertyAnimator: UIViewPropertyAnimator?
    
    init(animationType: AnimationType, animationDuration: TimeInterval = 0.3, anchorView: UIView?) {
        self.animationType = animationType
        self.anchorView = anchorView
        self.animationDuration = animationDuration
        
        if let anchorView = anchorView {
            anchorViewCenter = anchorView.superview?.convert(anchorView.center, to: nil) ?? .zero
            anchorViewSize = anchorView.bounds.size
            anchorViewTag = anchorView.tag
        } else {
            anchorViewCenter = .zero
            anchorViewSize = .zero
            anchorViewTag = 0
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .present:
            guard let toViewController = transitionContext.viewController(forKey: .to) else {
                return transitionContext.completeTransition(false)
            }
            transitionContext.containerView.insertSubview(toViewController.view, at: 1) // In between the presentations controller's background and close button
            
            toViewController.view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            toViewController.view.layoutIfNeeded()
            propertyAnimator = presentAnimator(with: transitionContext, animating: toViewController)
        case .dismiss:
            guard let fromViewController = transitionContext.viewController(forKey: .from) else {
                return transitionContext.completeTransition(false)
            }
            propertyAnimator = dismissAnimator(with: transitionContext, animating: fromViewController)
        }
    }
    
    private func presentAnimator(with transitionContext: UIViewControllerContextTransitioning,
                                 animating viewController: UIViewController) -> UIViewPropertyAnimator {
        let view: UIView = viewController.view.viewWithTag(anchorViewTag) ?? viewController.view
        let finalSize = view.bounds.size
        let finalCenter = view.center
        view.transform = CGAffineTransform(scaleX: anchorViewSize.width / finalSize.width,
                                           y: anchorViewSize.height / finalSize.height)
        view.center = view.superview!.convert(anchorViewCenter, from: nil)
        anchorView?.isHidden = true
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut], animations: {
            view.transform = .identity
            view.center = finalCenter
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func dismissAnimator(with transitionContext: UIViewControllerContextTransitioning,
                                 animating viewController: UIViewController) -> UIViewPropertyAnimator {
        let view: UIView = viewController.view.viewWithTag(anchorViewTag) ?? viewController.view
        let initialSize = view.bounds.size
        let center = view.superview!.convert(anchorViewCenter, from: nil)
        let finalCenter = CGPoint(x: center.x, y: center.y + (anchorView?.frame.size.height ?? 0) / 2)
        let finalTransform = CGAffineTransform(scaleX: self.anchorViewSize.width / initialSize.width,
                                               y: self.anchorViewSize.height / initialSize.height)
        return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut], animations: {
            view.transform = finalTransform
            view.center = finalCenter
        }, completion: { _ in
            self.anchorView?.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
