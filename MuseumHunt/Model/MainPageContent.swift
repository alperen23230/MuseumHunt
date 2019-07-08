//
//  Content.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 8.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation


struct MainPageContent: Codable {
    var name: String
    var title: String
    var description: String
    var mainImageURL: String
    var videoURL: String?
    var slideImageURL: String?
    var audioURL: String?
    var text: String?
}
