//
//  MainPageContentViewModel.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 8.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

final class MainPageContentViewModel {
    
    let realm = try! Realm()
    
    var mainPageContentsCache : Results<MainPageContentCache>?
    
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
    
}
