//
//  ArtifactCache.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 4.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

class ArtifactCache: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var roomName : String = ""
    @objc dynamic var floorName : String = ""
    @objc dynamic var buildingName : String = ""
    @objc dynamic var imageURL : String = ""
    @objc dynamic var isTravel : Bool = false
    @objc dynamic var willTravel : Bool = true
}

extension ArtifactCache {
    //This method for comparison of 2 Artifact Cache Model
    override func isEqual(_ object: Any?) -> Bool {
        return name == (object as? ArtifactCache)?.name && roomName == (object as? ArtifactCache)?.roomName && floorName == (object as? ArtifactCache)?.floorName && buildingName == (object as? ArtifactCache)?.buildingName && imageURL == (object as? ArtifactCache)?.imageURL && isTravel == (object as? ArtifactCache)?.isTravel && willTravel == (object as? ArtifactCache)?.willTravel
    }
}
