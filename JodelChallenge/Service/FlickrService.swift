//
//  PhotosService.swift
//  JodelChallenge
//
//  Created by Igor on 01.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotosService {
    func photos(for page: Int) -> Observable<[FlickrPhoto]>
}

struct FlickrService: PhotosService {
    
    private let client: HTTPClient
    private let baseURL: String
    private let apiKey: String
    
    init(
        client: HTTPClient,
        baseURL: String = "https://api.flickr.com/services/rest/",
        apiKey: String
    ) {
        self.client = client
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    func photos(for page: Int) -> Observable<[FlickrPhoto]> {
        var urlComponents = URLComponents(string: baseURL)!

        let queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                          URLQueryItem(name: "format", value: "json"),
                          URLQueryItem(name: "method", value: "flickr.interestingness.getList"),
                          URLQueryItem(name: "nojsoncallback", value: "1"),
                          URLQueryItem(name: "page", value: String(page)),
                          URLQueryItem(name: "per_page", value: "10")]

        urlComponents.queryItems = queryItems

        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")

        let flickrResponse: Observable<FlickrResponse> = client.call(request)

        return flickrResponse.map {$0.photos}
    }
}
