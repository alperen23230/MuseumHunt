//
//  ArtifactViewModel.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 3.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

class ArtifactViewModel {
    
    let realm = try! Realm()
    
    var artifactsCache : Results<ArtifactCache>?
    
    
    func saveArtifactCache(artifact: ArtifactCache){
        do{
            try realm.write {
                realm.add(artifact)
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    func loadArtifacts(){
        artifactsCache = realm.objects(ArtifactCache.self)
    }
    func updateArtifact(artifact: ArtifactCache){
        do{
            try realm.write {
                artifact.willTravel = !artifact.willTravel
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
}
