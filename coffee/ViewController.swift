//
//  ViewController.swift
//  coffee
//
//  Created by admin on 10/26/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
import Alamofire
import MapKit


class ViewController: UIViewController {
    
    var restaurantData: String!
    var restaurantKeyword: String!
    var restaurantType: String!
    
    var cafes = [ [String : CLLocationCoordinate2D] ]()
    var mkCafes: [Cafes] = []
    
    var locationManager: CLLocationManager?
    var startLocation: CLLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var userLocationIsSet: Bool!
    var cafeDataIsSet = false

    
    typealias DownloadComplete = () -> ()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userSpeechHandling()
        
        mapView?.delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
        
        

    }
    
    func userSpeechHandling() {
        guard restaurantData != nil else {
            print("JETT: No speech results were set, coffee is the default")
            return
        }
        if let phrase = restaurantData {
          let keywordArray = phrase.components(separatedBy: " ")
          restaurantKeyword = keywordArray[0]
          print("JETT: \(keywordArray[0])")
        }
        
        
        
        
    }


}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let distance: CLLocationDistance = 10000.0
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, distance, distance)
        mapView.setRegion(region, animated: true)

        if userLocationIsSet == nil || userLocationIsSet == false {
            getCoffeeShopData(userLocation: userLocation.coordinate)
        }
       // mapView.addAnnotation(cafes as! MKAnnotation)
        userLocationIsSet = true;
        
        if cafeDataIsSet == true {
            print("JETT RAINES: \(mkCafes)")
            mapView.addAnnotations(mkCafes)
            
            cafeDataIsSet = false
        }
        

        
    }
    
    // Alamofire Get Restaurant JSON
    func getCoffeeShopData (userLocation: CLLocationCoordinate2D) {
       
        var type: String!
        if restaurantKeyword == nil {
            type = "cafe"
            restaurantKeyword = "cafe"
        } else {
            type = "restaurant"
        }
        
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(userLocation.latitude),\(userLocation.longitude)&radius=5000&type=\(type!)&keyword=\(restaurantKeyword!)&key=AIzaSyAL-xs06cyaLuDSvF9AHv7p05VKhyCxS7E").responseJSON { response in
    print(response.request)  // original URL request
    print(response.response) // HTTP URL response
    print(response.data)     // server data
    print(response.result)   // result of response serialization
    
    if let JSON = response.result.value {
        if let dict = JSON as? Dictionary<String, Any> {
            if let list = dict["results"] as? [Dictionary<String, Any>] {
                //print("JETT RAINES: \(list[0])")
                // Create our local variables
                
                var cafeName: String!
                var cafeLocation: CLLocationCoordinate2D!
                
                //print("LIST COUNT: \(list.count)")
                for i in 0 ..< list.count {
                if let name = list[i]["name"] {
               // print("NAME OF RESTAURANT: \(name)")
                cafeName = name as! String
                }
                if let geometry = list[i]["geometry"] as? Dictionary<String, Any> {
                    if let location = geometry["location"] as? Dictionary<String, Any> {
                        //print("Restaurant Location: \(location)")
                        let latitude = location["lat"]
                            //print("RESTAURANT LAT: \(latitude)")
                        let longitude = location["lng"]
                            //print("RESTAURANT LNG: \(longitude)")
                        cafeLocation = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                        
                        
                    }
                }
            let newCafe = Cafes(name: cafeName!, latitude: (cafeLocation.latitude as? Double)!, longitude: (cafeLocation.longitude as Double?)!, cafeDescription: "haha")
            self.mkCafes.append(newCafe)
            
            
            }
        }
        }
    }
      self.cafeDataIsSet = true;
    }
    
    
}
    
}
extension ViewController: CLLocationManagerDelegate {
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if startLocation == nil {
//            startLocation = locations.first
//        } else {
//            guard let latest = locations.first else { return }
//            let distanceInMeters = startLocation?.distance(from: latest)
//            print("Distance in meters: \(distanceInMeters)")
//            
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager?.startUpdatingLocation()
//        }
//    }
}

