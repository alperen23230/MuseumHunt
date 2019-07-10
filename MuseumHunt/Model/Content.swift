//
//  Content.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 9.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation

struct Content: Codable, Equatable {
    var mainImageURL: String?
    var title: String?
    var videoURL: String?
    var slideImageURL: String?
    var audioURL: String?
    var text: String?
}

extension Content {
    static func ==(lhs: Content, rhs: Content) -> Bool {
        return lhs.mainImageURL == rhs.mainImageURL && lhs.title == rhs.title && lhs.videoURL == rhs.videoURL && lhs.slideImageURL == rhs.slideImageURL && lhs.audioURL == rhs.audioURL && lhs.text == rhs.text
    }
}
