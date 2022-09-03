//
//  ViewModel.swift
//  JodelChallenge
//
//  Created by Igor on 01.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()

}
