//
//  APIClientTests.swift
//  MuseumHuntTests
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import XCTest
@testable import MuseumHunt

class APIClientTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAPIClientURLComponent(){
        let url = "https://api.com/getAllBeacons"
        
        guard let realURL = URL(string: url) else { XCTFail(); return }
        var apiClient = APIClient(urlHost: "api.com", endpoint: EndPoint.getAllMainPageContents)
        apiClient.endpoint = EndPoint.getAllBeacons
        
        XCTAssertEqual(apiClient.urlComponent.url, realURL)
    }

}
