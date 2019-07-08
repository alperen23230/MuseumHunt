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

    var sut: Beacon!
    
    override func setUp() {
        sut = Beacon(uuid: "abc", major: 123, minor: 456, proximity: nil)
    }

    override func tearDown() {
       sut = nil
    }

    func testBeaconModelInit_whenCreate_takeSameValue(){
        
        let beacon = Beacon(uuid: "abc", major: 123, minor: 456, proximity: nil)
        
        XCTAssertEqual(sut, beacon)
    }
}
