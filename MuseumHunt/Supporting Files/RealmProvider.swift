//
//  RealmProvider.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 5.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider {
    class func realm() -> Realm {
        if let _ = NSClassFromString("XCTest") {
            return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test", encryptionKey: nil, readOnly: false, schemaVersion: 0, migrationBlock: nil, objectTypes: nil))
        } else {
            return try! Realm();
        }
    }
}
