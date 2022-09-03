//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FeedViewController : UITableViewController {
    
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()
    private var fullScreenTransitionManager: FullScreenTransitionManager?
    let isHeaderLoading = BehaviorRelay(value: false)

    lazy var headerRefreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        return view
    }()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        title = "Flickr Feed"
    }
    
    fileprivate func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.resuseId)
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray5
        tableView.refreshControl = headerRefreshControl
    }
    
    fileprivate func bindViewModel() {
        guard let viewModel = self.viewModel as? FeedViewModel else { return }
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: disposeBag)
        viewModel.headerLoading.asObservable()
            .bind(to: headerRefreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
            
        let headerRefresh = headerRefreshControl.rx.controlEvent(.valueChanged).map { _ in ()}.mapToVoid()
        
        let output = viewModel.transform(input: .init(
                                            refreshTrigger: .just(()),
                                            headerRefresh: headerRefresh,
                                            loadMoreTrigger: tableView.rx.reachedBottom().mapToVoid().skip(1)))
        
        output
            .items
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: FeedCell.resuseId, cellType: FeedCell.self))
        { tableView, viewModel, cell in
            cell.bind(to: viewModel)
        }.disposed(by: disposeBag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(FeedCellViewModel.self))
            .bind { [weak self] indexPath, model in
                let tag = Int(model.photo.id ?? "") ?? 0
                let cell = self?.tableView.cellForRow(at: indexPath) as? FeedCell
                let fullScreenTransitionManager = FullScreenTransitionManager(anchorViewTag: tag)
                let fullScreenImageViewController = FullScreenImageViewController(image: cell?.photoImageView.image, tag: tag)
                fullScreenImageViewController.modalPresentationStyle = .custom
                fullScreenImageViewController.transitioningDelegate = fullScreenTransitionManager
                self?.present(fullScreenImageViewController, animated: true)
                self?.fullScreenTransitionManager = fullScreenTransitionManager

            }
            .disposed(by: disposeBag)
    }
    
    
}
