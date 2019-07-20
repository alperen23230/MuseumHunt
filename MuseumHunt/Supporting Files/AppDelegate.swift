//
//  AppDelegate.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 28.06.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import RealmSwift
import CoreBluetooth
import ChameleonFramework
import KRProgressHUD

var launch = ""

var currentBluetoothState = ""

//This url base for photos, videos, audios ... from API
let urlBase = "https://jwtapi20190719101048.blob.core.windows.net/beamityblob/"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var manager: CBCentralManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = UIColor.flatMagenta()
        
        UITabBar.appearance().tintColor = UIColor.flatMagenta()
        
        KRProgressHUD.set(activityIndicatorViewColors: [UIColor.flatMagenta(), UIColor.white])
        KRProgressHUD.set(font: UIFont(name: "SFProDisplay-Regular", size: 17)!)
        
        
        manager = CBCentralManager()
        manager.delegate = self
        
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

extension AppDelegate: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth On")
            currentBluetoothState = "On"
            break
        case .poweredOff:
            print("Bluetooth Off")
            currentBluetoothState = "Off"
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unsupported:
            break
        case .unknown:
            break
        default:
            break
        }
    }
}

