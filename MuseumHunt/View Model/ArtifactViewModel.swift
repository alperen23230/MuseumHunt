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
    
    var artifacts = [Artifact]()
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
    mutating func loadCategories(){
        artifactsCache = realm.objects(ArtifactCache.self)
    }
}
