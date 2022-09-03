//
//  FeedCellViewModel.swift
//  JodelChallenge
//
//  Created by Igor on 02.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa



class FeedCellViewModel: TableViewCellViewModel {

    let photo: FlickrPhoto

    init(with photo: FlickrPhoto) {
        self.photo = photo
        super.init()
        title.accept(photo.title)
        
        if let farm = photo.farm,
            let server = photo.server,
            let id = photo.id,
            let secret = photo.secret
        {
            imageUrl.accept(buildUrl(with: farm, server: server, id: id, secret: secret))
        }
    }
    
    fileprivate func buildUrl(with farm: Int, server: String, id: String, secret: String) -> String {
        return "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret)_m.jpg"
    }                 
}
