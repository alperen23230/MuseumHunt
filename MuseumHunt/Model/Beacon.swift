//
//  Beacon.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation

struct Beacon: Codable, Equatable {
    
    var uuid: String
    var major: Int
    var minor: Int
    var proximity: String?
    
}

extension Beacon {
    //This method for comparison of 2 Beacon
    static func ==(lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.major == rhs.major && lhs.minor == rhs.minor
    }
}
