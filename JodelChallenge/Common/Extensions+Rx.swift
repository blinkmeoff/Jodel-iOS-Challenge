//
//  Extensions+Rx.swift
//  JodelChallenge
//
//  Created by Igor on 02.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

protocol OptionalType {
    associatedtype Wrapped
    
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension Observable where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}

extension ObservableType {

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

public extension Reactive where Base: UIScrollView {
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
        return ControlEvent(events: source)
    }
}


extension Reactive where Base: UIImageView {
    
    public var imageURL: Binder<URL?> {
        return self.imageURL(withPlaceholder: nil)
    }
    
    public func imageURL(withPlaceholder placeholderImage: UIImage?, options: KingfisherOptionsInfo? = []) -> Binder<URL?> {
        return Binder(self.base, binding: { (imageView, url) in
            imageView.kf.setImage(with: url,
                                  placeholder: placeholderImage,
                                  options: options,
                                  progressBlock: nil,
                                  completionHandler: { (result) in })
        })
    }
}
