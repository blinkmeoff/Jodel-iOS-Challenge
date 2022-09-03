//
//  JodelChallengeTests.swift
//  JodelChallengeTests
//
//  Created by Michal Ciurus on 21/09/2017.
//  Copyright © 2017 Jodel. All rights reserved.
//

import XCTest
import Foundation
import RxTest
import RxBlocking

@testable import JodelChallenge

class JodelChallengeTests: XCTestCase {
    
    let mockService: PhotosService = MockFlickrService()
    
    func test_decoding() {
        let firstPhoto = try! mockService.photos(for: 1).toBlocking().first()
        
        let id = "52328546498"
        let owner = "114799538@N08"
        let secret = "0a61ae3a69"
        let server = "65535"
        let farm = 66
        let title = "Nature heals soul ( Reverence Part II )"
        

        XCTAssertEqual(firstPhoto?.first?.id, id)
        XCTAssertEqual(firstPhoto?.first?.owner, owner)
        XCTAssertEqual(firstPhoto?.first?.secret, secret)
        XCTAssertEqual(firstPhoto?.first?.server, server)
        XCTAssertEqual(firstPhoto?.first?.farm, farm)
        XCTAssertEqual(firstPhoto?.first?.title, title)
    }
    
    func test_constructed_url() {
        if let firstPhoto = try! mockService.photos(for: 1).toBlocking().first()?.first {
            let feedCellViewModel = FeedCellViewModel(with: firstPhoto)
            
            XCTAssertTrue(feedCellViewModel.imageUrl.value!.contains(String(firstPhoto.farm)))
            XCTAssertTrue(feedCellViewModel.imageUrl.value!.contains(String(firstPhoto.server)))
            XCTAssertTrue(feedCellViewModel.imageUrl.value!.contains(firstPhoto.secret))
            XCTAssertTrue(feedCellViewModel.imageUrl.value!.contains(firstPhoto.id))
        } else {
            XCTFail()
        }
    }
    
    
    
}

