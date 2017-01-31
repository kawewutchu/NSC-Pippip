//
//  getPlaceConditionController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/24/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
class getPlaceConditionController: UIViewController ,CLLocationManagerDelegate,GMSMapViewDelegate{

    @IBOutlet var mapView: GMSMapView!
    var cirlce: GMSCircle!
    var userChat = User()
    var latitude  = Double()
    var longitude = Double()
    var conlatitude = Double()
    var conlongitude = Double()
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
        
        observeCondition()
        
    }
    
    let condition = Condition()
    
    func  observeCondition() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userMessagesRef = FIRDatabase.database().reference().child("user-condition").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("condition").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                
                self.condition.setValuesForKeys(dictionary)
                //  self.messages.append(Message(dictionary: dictionary))
                print(self.condition.text)
                print(self.userChat.id)
                let chatPartnerId =  self.condition.chatPartnerId()
                print(chatPartnerId)
                if chatPartnerId == self.userChat.id{
                    let text = self.condition.text
                    print(text)
                   // let imageUrl = condition.imageUrl
                    if(self.condition.latitude != nil){
                        self.conlatitude = self.condition.latitude
                        self.conlongitude = self.condition.longtitude
                    }
                   
                   
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
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
    func getCondition(){
        if(checkgetCon){
//            let alert = UIAlertController(title: "ข้อความที่ได้รับ",
//                                          message: condition.text!,
//                                          preferredStyle: UIAlertControllerStyle.alert)
//            
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                (result : UIAlertAction) -> Void in
//                print(self.longitude)
//            }
//            alert.addAction(okAction)
//            
//            self.present(alert, animated: true, completion: nil)
        }
        checkgetCon = false

    }
    
    var checkgetCon = true
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if(checkgetCon){
            if(conlongitude - longitude <= 1){
                if(conlatitude - latitude <= 1)
                {
                    getCondition()
                }
            }
        }
        
        mapView.selectedMarker = marker
        latitude = position.target.latitude
        longitude = position.target.longitude
    }
    
}
