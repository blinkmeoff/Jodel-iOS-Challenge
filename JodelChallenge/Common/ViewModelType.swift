//
//  ViewModel.swift
//  JodelChallenge
//
//  Created by Igor on 01.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

struct FlickrError {
    let message: String?
}

class ViewModel {
    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
    let error = ErrorTracker()
    let parsedError = PublishSubject<ApiError>()
    let disposeBag = DisposeBag()

    init() {
        error.asObservable().map { (error) -> ApiError? in
            if let err = error as? ApiError {
                return err
            }
            return ApiError.serverError
        }.filterNil().bind(to: parsedError).disposed(by: disposeBag)
    }
}
