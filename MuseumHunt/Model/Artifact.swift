//
//  Artifact.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 3.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import UIKit

struct Artifact: Codable {
    var name: String
    var mainImageURL: String
    var roomName: String
    var floorName: String
    var buildingName: String
}
