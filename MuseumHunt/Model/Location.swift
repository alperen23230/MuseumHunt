//
//  Location.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 5.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation

struct Location: Codable {
    var id: String
    var name: String
    var latitude: String
    var longitude: String
    var photoURL: String
    var distance: Int?

}
