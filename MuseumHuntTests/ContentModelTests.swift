//
//  ContentModelTests.swift
//  MuseumHuntTests
//
//  Created by Alperen Ünal on 10.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import XCTest
@testable import MuseumHunt

class ContentModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test(){
        let content = Content(mainImageURL: nil, title: nil, videoURL: nil, slideImageURL: nil, audioURL: nil, text: nil)
        let content2 = Content(mainImageURL: nil, title: nil, videoURL: nil, slideImageURL: nil, audioURL: nil, text: nil)
        XCTAssertEqual(content, content2)
    }

}
