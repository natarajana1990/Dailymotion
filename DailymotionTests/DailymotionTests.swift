//
//  DailymotionTests.swift
//  DailymotionTests
//
//  Created by Natarajan on 04/10/20.
//  Copyright © 2020 Natarajan. All rights reserved.
//

import XCTest
@testable import Dailymotion

class DailymotionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDownloadVideos() {
        let tmpInteractor = Interactor()
        let promise = expectation(description: "Download Video List")
        tmpInteractor.downloadVideoList(page: 1) { (videos, error) in
            XCTAssertTrue(videos != nil)
            XCTAssertTrue(error == nil)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDownloadVideosForUnAvailablePages() {
        let tmpInteractor = Interactor()
        let promise = expectation(description: "Download Video List")
        tmpInteractor.downloadVideoList(page: 10000) { (videos, error) in
            XCTAssertTrue(videos == nil)
            XCTAssertTrue(error != nil)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDownloadVideosForNegativePages() {
        let tmpInteractor = Interactor()
        let promise = expectation(description: "Download Video List")
        tmpInteractor.downloadVideoList(page: -5) { (videos, error) in
            XCTAssertTrue(videos == nil)
            XCTAssertTrue(error != nil)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDownloadVideosThumbnailImages() {
        let tmpInteractor = Interactor()
        let promise = expectation(description: "Download Video Thumbnail Image")
        tmpInteractor.downloadVideoList(page: 1) { (videos, error) in
            XCTAssertTrue(videos != nil)
            XCTAssertTrue(error == nil)
            
            if(videos != nil && videos!.list != nil && videos!.list!.count > 0) {
                let tmpVideoInfo = videos?.list![0]
                tmpInteractor.downloadImage(url: tmpVideoInfo?.thumbnail_240_url) { (image, imgError) in
                    XCTAssertTrue(image != nil)
                    XCTAssertTrue(error == nil)
                    promise.fulfill()
                }
            }
            else {
                XCTAssertTrue(false)
            }
        }
        waitForExpectations(timeout: 7, handler: nil)
    }
}
