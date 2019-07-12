//
//  AboutViewController.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 5.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import MapKit
import KRProgressHUD

class AboutViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var museumNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //We are fetching location from API
        fetchLocation()
    }
    
    func fetchLocation(){
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
//        APIClient.sharedInstance.getLocation { (result) in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let location):
//                //And pass location to showOnMap function for showing location on the map
//                self.showOnMap(with: location)
//                DispatchQueue.main.async {
//                    self.museumNameLabel.text = location.name
//                    KRProgressHUD.dismiss()
//                }
//            }
//        }
    }
    
    func showOnMap(with location: Location){
        
        let latitude = Double(location.latitude)!
        let longitude = Double(location.longitude)!
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: locationCoordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = locationCoordinate
        pointAnnotation.title = location.name
        
        mapView.addAnnotation(pointAnnotation)
    }
    
}
