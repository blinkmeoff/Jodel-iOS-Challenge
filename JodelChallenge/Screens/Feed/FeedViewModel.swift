//
//  FeedViewModel.swift
//  JodelChallenge
//
//  Created by Igor on 01.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FeedViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let refreshTrigger: Observable<Void>
        let headerRefresh: Observable<Void>
        let loadMoreTrigger: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[FeedCellViewModel]>
    }
    
    private let photosService: PhotosService
    private var page = 1
    private let disposeBag = DisposeBag()

    init(photosService: PhotosService) {
        self.photosService = photosService
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[FeedCellViewModel]>(value: [])
        
        Observable.of(input.refreshTrigger, input.headerRefresh).merge().flatMapLatest { [weak self] (_) -> Observable<([FlickrPhoto])> in
            guard let strongSelf = self else { return Observable.just(([])) }
            strongSelf.page = 1
            
            return strongSelf.photosService.photos(for: strongSelf.page)
                .trackActivity(strongSelf.headerLoading)
        }.map { $0.map({ (photo) -> FeedCellViewModel in
            FeedCellViewModel(with: photo)
        })}.subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: disposeBag)
        
        input.loadMoreTrigger.flatMapLatest { [weak self] (_) -> Observable<([FlickrPhoto])> in
            guard let strongSelf = self else { return Observable.just(([])) }
            strongSelf.page = strongSelf.page + 1
            print("Load page number - \(strongSelf.page)")
            return strongSelf.photosService.photos(for: strongSelf.page)
                .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
                .trackActivity(strongSelf.footerLoading)
        }
        .observe(on: MainScheduler.instance)
        .map { $0.map({ (photo) -> FeedCellViewModel in
            FeedCellViewModel(with: photo)
        })}
        .subscribe(onNext: { (items) in
            elements.accept(elements.value + items)
        }).disposed(by: disposeBag)
        
        return Output(items: elements)
    }
}
