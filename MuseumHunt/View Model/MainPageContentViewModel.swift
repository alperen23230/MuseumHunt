//
//  MainPageContentViewModel.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 8.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

final class MainPageContentViewModel {
    
    let realm = try! Realm()
    
    var mainPageContentsCache : Results<MainPageContentCache>?
    
    static var allBeacons = [Beacon]()
    
    func saveMainPageContentCache(content: MainPageContentCache){
        do{
            try realm.write {
                realm.add(content)
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
    func loadMainPageContents(){
        mainPageContentsCache = realm.objects(MainPageContentCache.self)
    }
    func clearMainPageContentCache(){
        do{
            try self.realm.write {
                loadMainPageContents()
                //And delete main page contents in cache
                realm.delete(mainPageContentsCache!)
            }
        }
        catch{
            print("Error: \(error)")
        }
    }
}
