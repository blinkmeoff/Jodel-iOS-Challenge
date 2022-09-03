//
//  MockFlickrService.swift
//  JodelChallenge
//
//  Created by Igor on 03.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation
import RxSwift

class MockFlickrService: PhotosService {
    
    let jsonDecoder = JSONDecoder()
    
    func photos(for page: Int) -> Observable<[FlickrPhoto]> {
        return Observable.create { [weak self] observer in
            if let jsonData = self?.loadJson(for: page == 1 ? "FlickrMockResponse" : ""),
               let mock = try? self?.jsonDecoder.decode(FlickrResponse.self, from: jsonData) {
                
                let photos = mock.photos.map { $0 }
                observer.onNext(photos)
            } else {
                observer.onError(ApiError.decodingError)
            }
            observer.onCompleted()
            
            return Disposables.create {
            }
        }
    }
    
    func loadJson(for fileName: String) -> Data? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                return try Data(contentsOf: url)
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

}
