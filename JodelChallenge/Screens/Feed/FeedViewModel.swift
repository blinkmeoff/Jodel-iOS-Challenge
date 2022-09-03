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

    init(photosService: PhotosService) {
        self.photosService = photosService
        super.init()
    }
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[FeedCellViewModel]>(value: [])
        
        let headerRefresh = Observable.of(input.refreshTrigger, input.headerRefresh).merge().flatMapLatest { [weak self] (_) -> Observable<([FlickrPhoto])> in
            guard let strongSelf = self else { return Observable.just(([])) }
            strongSelf.page = 1
            
            return strongSelf.photosService.photos(for: strongSelf.page)
                .trackActivity(strongSelf.headerLoading)
                .trackError(strongSelf.error)
                .catch{ _ in Observable.just([]) }
        }.map { $0.map({ (photo) -> FeedCellViewModel in
            FeedCellViewModel(with: photo)
        })}.share()
        
        headerRefresh.subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: disposeBag)
        
        let footerRefresh = input.loadMoreTrigger.flatMapLatest { [weak self] (_) -> Observable<([FlickrPhoto])> in
            guard let strongSelf = self else { return Observable.just(([])) }
            strongSelf.page = strongSelf.page + 1
            print("Load page number - \(strongSelf.page)")
            return strongSelf.photosService.photos(for: strongSelf.page)
                .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
                .trackActivity(strongSelf.footerLoading)
                .catch{ _ in Observable.just([]) }
        }
        .observe(on: MainScheduler.instance)
        .map { $0.map({ (photo) -> FeedCellViewModel in
            FeedCellViewModel(with: photo)
        })}.share()
        
        
        footerRefresh.subscribe(onNext: { (items) in
            elements.accept(elements.value + items)
        }).disposed(by: disposeBag)
        
        return Output(items: elements)
    }
}
