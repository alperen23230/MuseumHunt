//
//  ArtifactViewModel.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 3.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

struct ArtifactViewModel {
    
    let realm = try! Realm()
    
    var artifactsCache : Results<ArtifactCache>?
    
    
    func fetchAndParseArtifacts(){
        APIClient.sharedInstance.fetchAllArtfiacts { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let artifacts):
                for artifact in artifacts{
                    DispatchQueue.main.async {
                        let artifactCache = ArtifactCache()
                        artifactCache.name = artifact.name
                        artifactCache.floorName = artifact.floorName
                        artifactCache.roomName = artifact.roomName
                        artifactCache.buildingName = artifact.buildingName
                        artifactCache.imageURL = artifact.mainImageURL
                        self.saveArtifactCache(artifact: artifactCache)
                    }
                }
            }
        }
    }
    
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
    mutating func loadCategories(){
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
