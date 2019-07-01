//
//  BeaconModelTests.swift
//  MuseumHuntTests
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import XCTest
@testable import MuseumHunt

class BeaconModelTests: XCTestCase {

    
    override func setUp() {
        
    }

    override func tearDown() {
       
    }

    func testBeaconModelInit_whenCreate_takeSameValue(){
        let beacon1 = Beacon(uuid: "abc", major: 123, minor: 456)
        let beacon2 = Beacon(uuid: "abc", major: 123, minor: 456)
        
        XCTAssertEqual(beacon1, beacon2)
    }
}
