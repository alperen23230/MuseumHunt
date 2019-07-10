//
//  MainPageTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 28.06.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import KRProgressHUD
import CoreLocation

class MainPageTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var mainPageContentVM: MainPageContentViewModel!
    
    let locationManager = CLLocationManager()
    
    var currentContent: Content!
    
    var beaconRegions = [CLBeaconRegion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPageContentVM = MainPageContentViewModel()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
                getContentWithBeacon(beaconRegion: beacons.first!)
        } else {
            print("unknown")
        }
    }

    func getContentWithBeacon(beaconRegion: CLBeacon){
         var beacon = Beacon(name: nil, uuid: beaconRegion.proximityUUID.uuidString, major: Int(truncating: beaconRegion.major), minor: Int(truncating: beaconRegion.minor), proximity: nil)
        switch beaconRegion.proximity {
        case .far:
            print("far")
            beacon.proximity = "Far"
            APIClient.sharedInstance.getContentWithBeacon(beacon: beacon) { (result) in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let content):
                    DispatchQueue.main.async {
                        self.currentContent = Content(mainImageURL: content.mainImageURL, title: content.title, videoURL: content.videoURL, slideImageURL: content.slideImageURL, audioURL: content.audioURL, text: content.text)
                        
                        let currentBeaconIndex = self.beaconRegions.firstIndex(of: CLBeaconRegion(proximityUUID: beaconRegion.proximityUUID, major: CLBeaconMajorValue(truncating: beaconRegion.major), minor: CLBeaconMinorValue(truncating: beaconRegion.minor), identifier: beaconRegion.proximityUUID.uuidString))
                        self.locationManager.stopRangingBeacons(in: self.beaconRegions[currentBeaconIndex!])
                        
                        self.performSegue(withIdentifier: "goToContent", sender: nil)
                       
                    }
                }
            }
        case .near:
            print("near")
            beacon.proximity = "Near"
            APIClient.sharedInstance.getContentWithBeacon(beacon: beacon) { (result) in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let content):
                    DispatchQueue.main.async {
                        self.currentContent = Content(mainImageURL: content.mainImageURL, title: content.title, videoURL: content.videoURL, slideImageURL: content.slideImageURL, audioURL: content.audioURL, text: content.text)
                        
                        let currentBeaconIndex = self.beaconRegions.firstIndex(of: CLBeaconRegion(proximityUUID: beaconRegion.proximityUUID, major: CLBeaconMajorValue(truncating: beaconRegion.major), minor: CLBeaconMinorValue(truncating: beaconRegion.minor), identifier: beaconRegion.proximityUUID.uuidString))
                        
                        self.locationManager.stopRangingBeacons(in: self.beaconRegions[currentBeaconIndex!])
                        
                        self.performSegue(withIdentifier: "goToContent", sender: nil)
                        
                       
                    }
                }
            }
        case .immediate:
            print("immediate")
            beacon.proximity = "Immediate"
            APIClient.sharedInstance.getContentWithBeacon(beacon: beacon) { (result) in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let content):
                    DispatchQueue.main.async {
                        self.currentContent = Content(mainImageURL: content.mainImageURL, title: content.title, videoURL: content.videoURL, slideImageURL: content.slideImageURL, audioURL: content.audioURL, text: content.text)
                        
                        let currentBeaconIndex = self.beaconRegions.firstIndex(of: CLBeaconRegion(proximityUUID: beaconRegion.proximityUUID, major: CLBeaconMajorValue(truncating: beaconRegion.major), minor: CLBeaconMinorValue(truncating: beaconRegion.minor), identifier: beaconRegion.proximityUUID.uuidString))
                        self.locationManager.stopRangingBeacons(in: self.beaconRegions[currentBeaconIndex!])
                        
                        self.performSegue(withIdentifier: "goToContent", sender: nil)
                        
                    }
                }
            }
        default:
            print("Unknown")
        }
    }
    
    func startBeaconScan(){
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        } else {
            for beacon in mainPageContentVM.allBeacons {
                guard let beaconUUID = UUID(uuidString: beacon.uuid) else { return }
                let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: CLBeaconMajorValue(beacon.major), minor: CLBeaconMinorValue(beacon.minor), identifier: beaconUUID.uuidString)
                beaconRegions.append(beaconRegion)
                //locationManager.startMonitoring(for: beaconRegion)
                locationManager.startRangingBeacons(in: beaconRegion)
            }
        }
    }
    
    @objc func openBluetooth(alert: UIAlertAction){
        let url = URL(string: "App-Prefs:root=Bluetooth") //for bluetooth setting
        let app = UIApplication.shared
        app.open(url!, options: [:])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isBluetoothOpen = UserDefaults.standard.bool(forKey: "isBluetoothOpen")
        if isBluetoothOpen {
            if currentBluetoothState == "Off" {
                let alert = UIAlertController(title: "Settings",
                                              message: "Please open your bluetooth for use this feature",
                                              preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Open Settings",
                                              style: UIAlertAction.Style.default,
                                              handler: openBluetooth))
                alert.addAction(UIAlertAction(title: "Cancel",
                                              style: UIAlertAction.Style.default,
                                              handler: nil))
                self.present(alert, animated: true)
            } else {
                print("fetching")
                fetchAllBeacons()
            }
        }
        
        //This user default for is fetched main page contents at least once
        let isFetched = UserDefaults.standard.bool(forKey: "isFetchedMainPage")
        if launch == "FirstTime" {
            if !isFetched {
                fetchMainPageContent()
                UserDefaults.standard.set(true, forKey: "isFetchedMainPage")
            } else {
                mainPageContentVM.loadMainPageContents()
                tableView.reloadData()
            }
        } else {
            //Realm Read Data
            mainPageContentVM.loadMainPageContents()
            tableView.reloadData()
        }
    }
    
    
    func fetchAllBeacons(){
        APIClient.sharedInstance.getAllBeacons { (result) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let beacons):
                DispatchQueue.main.async {
                    self.mainPageContentVM.allBeacons.append(contentsOf: beacons)
                    self.startBeaconScan()
                }
            }
        }
    }
    
    func fetchMainPageContent(){
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
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
                        self.tableView.reloadData()
                        KRProgressHUD.dismiss()
                    }
            }
        }
    }
}

extension MainPageTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPageContentVM.mainPageContentsCache?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageContentCell") as! MainPageContentTableViewCell
        
        let mainPageContent = mainPageContentVM.mainPageContentsCache?[indexPath.row]
        
        guard let content = mainPageContent else { return UITableViewCell() }
        
        cell.setMainPageContent(content: content)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToContent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ContentViewController{
            if let indexPath = tableView.indexPathForSelectedRow{
                let mainPageContent = mainPageContentVM.mainPageContentsCache?[indexPath.row]
                
                guard let content = mainPageContent else { return }
                
                destinationVC.content = Content(mainImageURL: content.mainImageURL, title: content.title, videoURL: content.videoURL, slideImageURL: content.slideImageURL, audioURL: content.audioURL, text: content.text)
            } else {
                destinationVC.content = currentContent
            }
        }
    }
}
