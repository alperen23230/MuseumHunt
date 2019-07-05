//
//  SettingsViewModel.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 5.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import KRProgressHUD
import RealmSwift


final class SettingsViewModel {
    
    //Lets create instance of Realm
    let realm = try! Realm()
    
    //This instance for some CRUD methods for artifact
    var artifactVM = ArtifactViewModel()
    
    func checkContentUpdate(){
        do{
            try self.realm.write {
                //First load artifacts in cache
                artifactVM.loadArtifacts()
                //And delete artifacts in cache
                realm.delete(artifactVM.artifactsCache!)
            }
            //After fetch new artifacts
            fetchNewArtifacts()
        }
        catch{
            print("Error: \(error)")
        }
        
    }
    
    func fetchNewArtifacts(){
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
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
                        self.artifactVM.saveArtifactCache(artifact: artifactCache)
                    }
                }
                DispatchQueue.main.async {
                    self.artifactVM.loadArtifacts()
                    KRProgressHUD.dismiss()
                }
            }
        }
    }
}
