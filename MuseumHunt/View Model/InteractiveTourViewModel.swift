//
//  InteractiveTourViewModel.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 18.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

final class InteractiveTourViewModel {
    
    static var allBeacons = [Beacon]()
    
    var beaconContents = [RelationBeacon]()
    
    var lastPostedBeacon: Beacon?
    
    let realm = try! Realm()
    
    var isNotTravelArtifacts: Results<ArtifactCache>?
    
    func updateArtifactIsTravelStatus(artifactName: String){
        let artifact = realm.objects(ArtifactCache.self).filter("name == %@", artifactName).first
        
        do{
            try realm.write {
                artifact?.isTravel = true
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    func getIsTravelFalse(){
        isNotTravelArtifacts = realm.objects(ArtifactCache.self).filter("isTravel == False AND willTravel == True")
    }
}
