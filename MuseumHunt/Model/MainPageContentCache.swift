//
//  MainPageContentCache.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 8.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

class MainPageContentCache: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descrpt: String = ""
    @objc dynamic var mainImageURL: String = ""
    @objc dynamic var videoURL: String?
    @objc dynamic var slideImageURL: String?
    @objc dynamic var audioURL: String?
    @objc dynamic var text: String?
}
