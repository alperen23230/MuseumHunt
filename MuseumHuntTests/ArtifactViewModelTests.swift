//
//  ArtifactViewModelTests.swift
//  MuseumHuntTests
//
//  Created by Alperen Ünal on 5.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import XCTest
import RealmSwift
@testable import MuseumHunt

class ArtifactViewModelTests: XCTestCase {
    
    var realm: Realm!
    
    override func setUp() {
        realm = RealmProvider.realm()
    }

    override func tearDown() {
        try! realm.write { 
            realm.deleteAll()
        }
    }
    
    //This function in the artifact VM
    func save(artifact: ArtifactCache){
        do{
            try realm.write {
                realm.add(artifact)
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    func testSaveArtifact(){
        //Create a Artifact Cache Model
        let artifact = ArtifactCache()
        artifact.name = "mona lisa"
        artifact.buildingName = "first building"
        artifact.floorName = "first floor"
        artifact.imageURL = "abc"
        artifact.roomName = "Renaissance"
        
        //And save cache with realm
        save(artifact: artifact)
        
        let artifactFromCache = realm.objects(ArtifactCache.self).last
        //Check is equal
        XCTAssertEqual(artifact, artifactFromCache)
    }

    
    
}
