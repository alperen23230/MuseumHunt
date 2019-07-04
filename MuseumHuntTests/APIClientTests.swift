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
    
    func testAPIClient_AllArtifactsFetching(){
        APIClient.sharedInstance.urlComponent.path = EndPoint.getAllArtifacts.rawValue
        
        let sessionAnsweredExpectation = expectation(description: "Session")
        
        guard let url = APIClient.sharedInstance.urlComponent.url else { XCTFail();return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            if error != nil{
                XCTFail(error!.localizedDescription)
            } else{
                guard let _ = response as? HTTPURLResponse, let jsonData = data  else { return }
                let artifactsData = try? JSONDecoder().decode([Artifact].self, from: jsonData)
                guard let artifacts = artifactsData else { return }
                sessionAnsweredExpectation.fulfill()
                XCTAssertNotNil(artifacts)
            }
            }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
    }

}
