//
//  TableViewCellViewModel.swift
//  JodelChallenge
//
//  Created by Igor on 02.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TableViewCellViewModel {
    let title = BehaviorRelay<String?>(value: nil)
    let imageUrl = BehaviorRelay<String?>(value: nil)
}
