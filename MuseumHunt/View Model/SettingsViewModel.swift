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
    var mainPageContentVM = MainPageContentViewModel()
    
    func checkContentUpdate(){
        do{
            try self.realm.write {
                //First load artifacts in cache
                artifactVM.loadArtifacts()
                //And delete artifacts in cache
                realm.delete(artifactVM.artifactsCache!)
                //First load main page contents in cache
                mainPageContentVM.loadMainPageContents()
                 //And delete main page contents in cache
                realm.delete(mainPageContentVM.mainPageContentsCache!)
            }
            //After fetch new artifacts
            fetchNewArtifacts()
            //After fetch new main pag contents
            fetchNewMainPageContents()
        }
        catch{
            print("Error: \(error)")
        }
        
    }
    
    func fetchNewMainPageContents(){
        APIClient.sharedInstance.getMainPageContent { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let mainPageContents):
                DispatchQueue.main.async {
                    _ = mainPageContents.map({
                        let mainPageContent = MainPageContentCache()
                        mainPageContent.name = $0.name
                        mainPageContent.title = $0.title
                        mainPageContent.descrpt = $0.description
                        mainPageContent.mainImageURL = $0.mainImageURL
                        mainPageContent.slideImageURL = $0.slideImageURL
                        mainPageContent.videoURL = $0.videoURL
                        mainPageContent.audioURL = $0.audioURL
                        mainPageContent.text = $0.text
                        self.mainPageContentVM.saveMainPageContentCache(content: mainPageContent)
                    })
                    self.mainPageContentVM.loadMainPageContents()
                    KRProgressHUD.dismiss()
                }
            }
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
                DispatchQueue.main.async {
                    for artifact in artifacts{
                        let artifactCache = ArtifactCache()
                        artifactCache.name = artifact.name
                        artifactCache.floorName = artifact.floorName
                        artifactCache.roomName = artifact.roomName
                        artifactCache.buildingName = artifact.buildingName
                        artifactCache.imageURL = artifact.mainImageURL
                        self.artifactVM.saveArtifactCache(artifact: artifactCache)
                    }
                    self.artifactVM.loadArtifacts()
                }
            }
        }
    }
}
