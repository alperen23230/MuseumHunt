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
        let urlString = "https://beamityapi20190703022513.azurewebsites.net/api/artifact/getallartifacts"
        
        guard let url = URL(string: urlString) else { XCTFail(); return }
        
        APIClient.sharedInstance.urlComponent.path = EndPoint.getAllArtifacts.rawValue
        
        XCTAssertEqual(APIClient.sharedInstance.urlComponent.url, url)
        
    }

}
