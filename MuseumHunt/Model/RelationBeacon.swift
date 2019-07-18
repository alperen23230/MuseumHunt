//
//  RelationBeacon.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 18.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation

struct RelationBeacon: Codable, Equatable {
    var artifactName: String?
    var contentName: String?
    var title: String?
    var description: String?
    var mainImageURL: String?
    var videoURL: String?
    var slideImageURL: String?
    var audioURL: String?
    var text: String?
    var isHomePage: Bool
    var isCampaign: Bool
}

extension RelationBeacon {
    static func ==(lhs: RelationBeacon, rhs: RelationBeacon) -> Bool {
        return lhs.mainImageURL == rhs.mainImageURL && lhs.title == rhs.title && lhs.videoURL == rhs.videoURL && lhs.slideImageURL == rhs.slideImageURL && lhs.audioURL == rhs.audioURL && lhs.text == rhs.text && lhs.isHomePage == rhs.isHomePage && lhs.isCampaign == rhs.isCampaign && lhs.artifactName == rhs.artifactName && lhs.contentName == rhs.contentName
    }
}
