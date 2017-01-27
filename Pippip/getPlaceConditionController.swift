//
//  getPlaceConditionController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/24/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit
import GoogleMaps
class getPlaceConditionController: UIViewController ,CLLocationManagerDelegate,GMSMapViewDelegate{

    @IBOutlet var mapView: GMSMapView!
    var cirlce: GMSCircle!
    
    var latitude  = Double()
    var longitude = Double()
    var name = String()
    var SID = String()
    var didFindMyLocation = false
    let locationManager = CLLocationManager()
    
    let conditionDefaults = Foundation.UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isMyLocationEnabled = true
        self.locationManager.requestWhenInUseAuthorization()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = mapView
        self.mapView.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    let marker = GMSMarker()
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            locationManager.stopUpdatingLocation()
        }
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        mapView.camera = GMSCameraPosition(target: locValue, zoom: 15, bearing: 0, viewingAngle: 0)
//        
//        marker.position = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
//        marker.title = "ตำแหน่งตอนนี้"
//        marker.snippet = "กดเพื่อตั้งเป็นบ้านของนักเรียน"
//        latitude = locValue.latitude
//        longitude = locValue.longitude
//        marker.map = mapView
        
        
        
    }
    
    
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        
//        
//        let alert = UIAlertController(title: "Add place!",
//                                      message: "!!!!!!!",
//                                      preferredStyle: UIAlertControllerStyle.alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
//            (result : UIAlertAction) -> Void in
//        }
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            (result : UIAlertAction) -> Void in
//            print(self.longitude)
//            self.conditionDefaults.set(self.longitude, forKey: "longtitude")
//            self.conditionDefaults.set(self.latitude, forKey: "latitude")
//        }
//        alert.addAction(okAction)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true, completion: nil)
//        
//        
//    }
    
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        return true
//    }
//    
    func pressed(){
        print("vbvb")
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //print("\(position.target.latitude) \(position.target.longitude)")
        
        
        //print(position.target)
        
//        marker.position = CLLocationCoordinate2DMake(position.target.latitude, position.target.longitude)
        mapView.selectedMarker = marker
        
        
        latitude = position.target.latitude
        longitude = position.target.longitude
    }
    
}
