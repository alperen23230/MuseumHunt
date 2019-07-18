//
//  RelationBeacon.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 18.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation

struct RelationBeacon: Codable{
    var artifactName: String
    var contentName: String
    var title: String
    var description: String?
    var mainImageURL: String
    var videoURL: String?
    var slideImageURL: String?
    var audioURL: String?
    var text: String?
    var isHomePage: Bool
    var isCampaign: Bool
}
