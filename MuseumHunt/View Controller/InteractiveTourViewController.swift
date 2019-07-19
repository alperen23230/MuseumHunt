//
//  InteractiveTourViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 18.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications


class InteractiveTourViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startStopButton: CustomTourButton!
    
    var isStartTour: Bool!
    
    var beaconRegions = [CLBeaconRegion]()
    
    var interactiveTourVM: InteractiveTourViewModel!
    
    let locationManager = CLLocationManager()
    
    var launchTour = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkFirstTimeTour()
        
        if launchTour == "FirstTime" {
            MyAlert.show(title: "Interactive Tours", description: "Here you can start the interactive tour you can visit the artifacts you want to visit.", buttonTxt: "OK")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted? \(granted)")
        }
        UNUserNotificationCenter.current().delegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        interactiveTourVM = InteractiveTourViewModel()
        
        isStartTour = UserDefaults.standard.bool(forKey: "isStartTour")
        
        if !isStartTour {
            startStopButton.stopAnimating()
            startStopButton.setTitle("Start Tour", for: .normal)
        } else {
            startStopButton.animatePulsatingLayer()
            InteractiveTourViewModel.allBeacons.removeAll()
             let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
            fetchAllBeacons(locationID: locationID!)
            startStopButton.setTitle("Stop Tour", for: .normal)
        }
        
    }
    
    func checkFirstTimeTour(){
        let checkFirstTimeTour = UserDefaults.standard.bool(forKey: "checkFirstTimeTour")
        
        if checkFirstTimeTour {
            launchTour = "BeforeLaunch"
        } else {
            launchTour = "FirstTime"
            UserDefaults.standard.set(true, forKey: "checkFirstTimeTour")
        }
    }
    
    @objc func openBluetooth(alert: UIAlertAction){
        let url = URL(string: "App-Prefs:root=General&path=Bluetooth") //for bluetooth setting
        let app = UIApplication.shared
        app.open(url!, options: [:])
    }
    
    @IBAction func startStopButtonClicked(_ sender: Any) {
        
         isStartTour = UserDefaults.standard.bool(forKey: "isStartTour")
        
        if !isStartTour {
            if currentBluetoothState == "On" {
                //Fetch beacons and start ranging, monitoring
                startStopButton.animatePulsatingLayer()
                let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
                fetchAllBeacons(locationID: locationID!)
                
                startStopButton.setTitle("Stop Tour", for: .normal)
                UserDefaults.standard.set(true, forKey: "isStartTour")
            } else {
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
            }
        } else {
            //Stop ranging and monitoring
            startStopButton.stopAnimating()
            stopBeaconScan()
            InteractiveTourViewModel.allBeacons.removeAll()
            beaconRegions.removeAll()
            interactiveTourVM.getIsTravelFalse()
            
            if interactiveTourVM.isNotTravelArtifacts?.count != 0{
                MyAlert.show(title: "Warning!", description: "There are still artifacts you haven't visited!", buttonTxt: "OK")
            }
            
            startStopButton.setTitle("Start Tour", for: .normal)
            UserDefaults.standard.set(false, forKey: "isStartTour")
        }
    }
    
    func fetchAllBeacons(locationID: String){
        let location = LocationJSONModel(id: locationID)
        APIClient.sharedInstance.getAllBeacons(location: location) { (result) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    MyAlert.show(title: "Error!", description: "Something went wrong!", buttonTxt: "OK")
                }
            case .success(let beacons):
                DispatchQueue.main.async {
                    InteractiveTourViewModel.allBeacons.append(contentsOf: beacons)
                    for beacon in InteractiveTourViewModel.allBeacons {
                        guard let beaconUUID = UUID(uuidString: beacon.uuid) else { return }
                        let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: CLBeaconMajorValue(beacon.major), minor: CLBeaconMinorValue(beacon.minor), identifier: beaconUUID.uuidString)
                        
                        beaconRegion.notifyOnEntry = true
                        beaconRegion.notifyOnExit = true
                        beaconRegion.notifyEntryStateOnDisplay = true
                        
                        self.beaconRegions.append(beaconRegion)
                    }
                    self.startBeaconScan()
                }
            }
        }
    }
    
    func startBeaconScan(){
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        } else {
            for beaconRegion in beaconRegions {
                locationManager.startMonitoring(for: beaconRegion)
                locationManager.startRangingBeacons(in: beaconRegion)
            }
        }
    }
    func stopBeaconScan(){
        for beacon in beaconRegions{
            locationManager.stopMonitoring(for: beacon)
            locationManager.stopRangingBeacons(in: beacon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter(){ $0.proximity != .unknown }
        if knownBeacons.count > 0 {
            checkBeaconForProximity(beaconRegion: knownBeacons.first!)
        } else {
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //Post for analytic
        
        postNotification(withBody: "Enter")
        print("didEnter")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExit")
    }
    
    func checkBeaconForProximity(beaconRegion: CLBeacon){
        var beacon = Beacon(name: nil, uuid: beaconRegion.proximityUUID.uuidString, major: Int(truncating: beaconRegion.major), minor: Int(truncating: beaconRegion.minor), proximity: nil)
        
                switch beaconRegion.proximity {
                case .far:
                    print("far")
                    let currentBeaconIndex = self.beaconRegions.firstIndex(of: CLBeaconRegion(proximityUUID: beaconRegion.proximityUUID, major: CLBeaconMajorValue(truncating: beaconRegion.major), minor: CLBeaconMinorValue(truncating: beaconRegion.minor), identifier: beaconRegion.proximityUUID.uuidString))
                   // self.locationManager.stopRangingBeacons(in: self.beaconRegions[currentBeaconIndex!])
                    beacon.proximity = "Far"
                    if interactiveTourVM.lastPostedBeacon != beacon {
                        getContentForBeacon(beacon: beacon, beaconRegion: self.beaconRegions[currentBeaconIndex!])
                        interactiveTourVM.lastPostedBeacon = beacon
                    }
                case .near:
                    print("near")
                    beacon.proximity = "Near"
                    let currentBeaconIndex = self.beaconRegions.firstIndex(of: CLBeaconRegion(proximityUUID: beaconRegion.proximityUUID, major: CLBeaconMajorValue(truncating: beaconRegion.major), minor: CLBeaconMinorValue(truncating: beaconRegion.minor), identifier: beaconRegion.proximityUUID.uuidString))
                   
                    if interactiveTourVM.lastPostedBeacon != beacon {
                        getContentForBeacon(beacon: beacon, beaconRegion: self.beaconRegions[currentBeaconIndex!])
                        interactiveTourVM.lastPostedBeacon = beacon
                    }
                    
                case .immediate:
                    print("immediate")
                    let currentBeaconIndex = self.beaconRegions.firstIndex(of: CLBeaconRegion(proximityUUID: beaconRegion.proximityUUID, major: CLBeaconMajorValue(truncating: beaconRegion.major), minor: CLBeaconMinorValue(truncating: beaconRegion.minor), identifier: beaconRegion.proximityUUID.uuidString))
                    
                    beacon.proximity = "Immediate"
                    if interactiveTourVM.lastPostedBeacon != beacon {
                        getContentForBeacon(beacon: beacon, beaconRegion: self.beaconRegions[currentBeaconIndex!])
                        interactiveTourVM.lastPostedBeacon = beacon
                    }
                default:
                    print("Unknown")
                }
    }
    
    func getContentForBeacon(beacon: Beacon, beaconRegion: CLBeaconRegion){
        APIClient.sharedInstance.getContentWithBeacon(beacon: beacon) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    MyAlert.show(title: "Error!", description: "Something went wrong!", buttonTxt: "OK")
                }
            case .success(let content):
                DispatchQueue.main.async {
                    let nilContent = RelationBeacon(artifactName: nil, contentName: nil, title: nil, description: nil, mainImageURL: nil, videoURL: nil, slideImageURL: nil, audioURL: nil, text: nil, isHomePage: false, isCampaign: false)
                    if content != nilContent {
                        var isSameContent = false
                        for beaconContent in self.interactiveTourVM.beaconContents {
                            if content == beaconContent {
                                isSameContent = true
                                break
                            }
                        }
                        if !isSameContent{
                            self.interactiveTourVM.updateArtifactIsTravelStatus(artifactName: content.artifactName!)
                            self.interactiveTourVM.beaconContents.append(content)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func postNotification(withBody body: String) {
        let content = UNMutableNotificationContent()
        content.title = "We have a content for you"
        content.body = "Please open your app and see the content"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "EntryNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
}

extension InteractiveTourViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactiveTourVM.beaconContents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beaconContentCell") as! BeaconContentTableViewCell
        
        let content = interactiveTourVM.beaconContents[indexPath.row]
        
        cell.setBeaconContent(content: content)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = interactiveTourVM.beaconContents[indexPath.row]
        
        if content.isCampaign {
            //Perform campaign segue
            performSegue(withIdentifier: "goToCampaignFromBeacon", sender: nil)
        } else {
            //Perform content segue
            performSegue(withIdentifier: "goToContentFromBeacon", sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToContentFromBeacon" {
            if let destVC = segue.destination as? ContentViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let content = interactiveTourVM.beaconContents[indexPath.row]
                    destVC.content = Content(mainImageURL: content.mainImageURL, title: content.title, videoURL: content.videoURL, slideImageURL: content.slideImageURL, audioURL: content.audioURL, text: content.text)
                }
            }
        } else {
            if let destVC = segue.destination as? CampaignContentViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let content = interactiveTourVM.beaconContents[indexPath.row]
                    destVC.campaign = Campaign(name: content.contentName!, title: content.title!, text: content.text!, mainImageURL: content.mainImageURL!)
                }
            }
        }
    }
}
