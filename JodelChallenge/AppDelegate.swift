//
//  AppDelegate.swift
//  JodelChallenge
//
//  Created by Michal Ciurus on 21/09/2017.
//  Copyright © 2017 Jodel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let flickrService = FlickrService(client: URLSessionHTTPClient(config: .default))
        let viewModel = FeedViewModel(photosService: flickrService)
        let feedVC = FeedViewController(viewModel: viewModel)
        window?.rootViewController = UINavigationController(rootViewController: feedVC)
        window?.makeKeyAndVisible()
        return true
    }
}

