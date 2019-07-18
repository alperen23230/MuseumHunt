//
//  InteractiveTourViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 18.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import CoreLocation

class InteractiveTourViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startStopButton: CustomTourButton!
    
    var isStartTour: Bool!
    
    var beaconRegions = [CLBeaconRegion]()
    
    var interactiveTourVM: InteractiveTourViewModel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        interactiveTourVM = InteractiveTourViewModel()
        
        isStartTour = UserDefaults.standard.bool(forKey: "isStartTour")
        
        if !isStartTour {
            startStopButton.setTitle("Start Tour", for: .normal)
            
        } else {
            InteractiveTourViewModel.allBeacons.removeAll()
             let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
            fetchAllBeacons(locationID: locationID!)
            startStopButton.setTitle("Stop Tour", for: .normal)
        }
        
    }
    
    @IBAction func startStopButtonClicked(_ sender: Any) {
        
         isStartTour = UserDefaults.standard.bool(forKey: "isStartTour")
        
        if !isStartTour {
            //Fetch beacons and start ranging, monitoring
            let locationID = UserDefaults.standard.string(forKey: "CurrentLocation")
            fetchAllBeacons(locationID: locationID!)
            
            
            
            startStopButton.setTitle("Stop Tour", for: .normal)
            UserDefaults.standard.set(true, forKey: "isStartTour")
        } else {
            //Stop ranging and monitoring
            InteractiveTourViewModel.allBeacons.removeAll()
            beaconRegions.removeAll()
            stopBeaconScan()
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
            case .success(let beacons):
                DispatchQueue.main.async {
                    InteractiveTourViewModel.allBeacons.append(contentsOf: beacons)
                    for beacon in InteractiveTourViewModel.allBeacons {
                        guard let beaconUUID = UUID(uuidString: beacon.uuid) else { return }
                        let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: CLBeaconMajorValue(beacon.major), minor: CLBeaconMinorValue(beacon.minor), identifier: beaconUUID.uuidString)
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
                //locationManager.startMonitoring(for: beaconRegion)
                locationManager.startRangingBeacons(in: beaconRegion)
            }
        }
    }
    func stopBeaconScan(){
        for beacon in beaconRegions{
            locationManager.stopRangingBeacons(in: beacon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter(){ $0.proximity != .unknown }
        if knownBeacons.count > 0 {
            print(knownBeacons.first?.rssi)
        } else {
            print("unknown")
        }
    }
    
}
