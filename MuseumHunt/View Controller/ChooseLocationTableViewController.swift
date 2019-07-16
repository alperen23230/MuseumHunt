//
//  ChooseLocationTableViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 12.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import KRProgressHUD
import CoreLocation

class ChooseLocationTableViewController: UITableViewController, CLLocationManagerDelegate {

    
    var chooseLocationVM: ChooseLocationViewModel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseLocationVM = ChooseLocationViewModel()
        
        locationManager.requestAlwaysAuthorization()
        
    }

    override func viewDidAppear(_ animated: Bool) {
       fetchAllLocations()
    }

    func fetchAllLocations(){
        DispatchQueue.main.async {
            KRProgressHUD.show(withMessage: "Please wait available museums loading")
        }
        APIClient.sharedInstance.getAllLocation { (result) in
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let locations):
                DispatchQueue.main.async {
                    self.chooseLocationVM.locations.append(contentsOf: locations)
                    self.tableView.reloadData()
                    
                    if CLLocationManager.locationServicesEnabled(){
                        self.locationManager.delegate = self
                        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                        self.locationManager.startUpdatingLocation()
                    } else {
                        //Open location settings
                        let alert = UIAlertController(title: "Settings",
                                                      message: "Please open your location services for use this feature",
                                                      preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Open Settings",
                                                      style: UIAlertAction.Style.default,
                                                      handler: self.openLocation))
                        alert.addAction(UIAlertAction(title: "Cancel",
                                                      style: UIAlertAction.Style.default,
                                                      handler: nil))
                        self.present(alert, animated: true)
                    }
                    
                    KRProgressHUD.dismiss()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for index in 0..<chooseLocationVM.locations.count {
            guard let userLocation = locations.last else { return }
            let locationCoordinate = CLLocation(latitude: Double(chooseLocationVM.locations[index].latitude)!, longitude: Double(chooseLocationVM.locations[index].longitude)!)
            let distance = userLocation.distance(from: locationCoordinate)
            chooseLocationVM.locations[index].distance = Int(distance) / 1000
        }
        
        tableView.reloadData()
    }
    
    @objc func openLocation(alert: UIAlertAction){
        let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") //for location setting
        let app = UIApplication.shared
        app.open(url!, options: [:])
    }

}

extension ChooseLocationTableViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseLocationVM.locations.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        chooseLocationVM.locations.sort(){$0.distance ?? 0 < $1.distance ?? 0}
        
        let location = chooseLocationVM.locations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! ChooseLocationTableViewCell
        
        cell.setLocationCell(location: location)
        
        return cell
    }
}
