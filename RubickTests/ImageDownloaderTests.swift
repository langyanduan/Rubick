//
//  ImageDownloaderTests.swift
//  Rubick
//
//  Created by WuFan on 16/9/24.
//
//

import XCTest
import Rubick

class ImageDownloaderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testFetchImage() {
        let expectation = self.expectation(description: "Swift Expectations")
        
        let urlString = "http://i0.itc.cn/20160924/3728_a90c89b4_f089_afc8_82a5_5a9ac0808d38_1.jpg"
        guard let url = URL(string: urlString) else {
            return
        }
        let downloader = ImageDownloader(processors: [
            ResizingImageProcessor(size: CGSize(width: 100, height: 100), mode: .scaleAspectFill),
            CircularImageProcessor(radius: 50)
        ])
        
        downloader.fetchImage(withURL: url) { (image, canceled) in
            XCTAssertFalse(canceled)
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
