//
//  AppDelegate.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 28.06.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import RealmSwift

var launch = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do{
            try Realm()
        }
        catch{
            print("Error: \(error)")
        }
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore {
            launch = "BeforeLaunch"
        } else {
            launch = "FirstTime"
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        return true
    }
}

