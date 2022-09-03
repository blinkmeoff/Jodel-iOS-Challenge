//
//  FlickrNetwork.swift
//  JodelChallenge
//
//  Created by Igor on 02.09.2022.
//  Copyright © 2022 Jodel. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ApiError: Error {
    case serverError
    case decodingError
    
    var message: String {
        switch self {
            case .serverError: return "It's not you, it's us!"
            case .decodingError: return "Decoding? Ugh.."
        }
    }
}

protocol HTTPClient {
    func call<T: Decodable>(_ request: URLRequest)  -> Observable<T>
}

class URLSessionHTTPClient: HTTPClient {
    private lazy var jsonDecoder = JSONDecoder()
    private var session: URLSession
    
    init(config: URLSessionConfiguration) {
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func call<T: Decodable>(_ request: URLRequest)  -> Observable<T> {
        return Observable.create { observer in
            let task = self.session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                if let httpResponse = response as? HTTPURLResponse {
                    do {
                        let responseData = data ?? Data()
                        if (200...399).contains(httpResponse.statusCode) {
                            let objs = try strongSelf.jsonDecoder.decode(T.self,
                                                                   from: responseData)
                            observer.onNext(objs)
                        } else {
                            observer.onError(ApiError.serverError)
                        }
                    } catch {
                        observer.onError(ApiError.decodingError)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
