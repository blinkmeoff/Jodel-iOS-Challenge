//
//  FlickrImage.swift
//  JodelChallenge
//
//  Created by Igor on 02.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation

struct FlickrResponse: Decodable {
    
    let photos: [FlickrPhoto]
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    
    enum RootKeys: String, CodingKey {
        case photos
    }
    
    enum NestedKeys: String, CodingKey {
        case page, pages, perpage, total, photo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)

        let nestedContainer = try container.nestedContainer(keyedBy: NestedKeys.self, forKey: .photos)
        self.page = try nestedContainer.decodeIfPresent(Int.self, forKey: .page)
        self.pages = try nestedContainer.decodeIfPresent(Int.self, forKey: .pages)
        self.perpage = try nestedContainer.decodeIfPresent(Int.self, forKey: .perpage)
        self.total = try nestedContainer.decodeIfPresent(Int.self, forKey: .total)
        self.photos = try nestedContainer.decodeIfPresent([FlickrPhoto].self, forKey: .photo) ?? []
    }
}

struct FlickrPhoto: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
}
