//
//  ViewController.swift
//  MapZadanie3
//
//  Created by Marcin Skowron on 15/11/2017.
//  Copyright © 2017 Marcin Skowron. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapVIew: MKMapView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    let geoCoder = CLGeocoder()
    
    @IBAction func startButtonAction(_ sender: Any) {
        self.stopButton.isEnabled = true
        self.startButton.isEnabled = false
        locManager.startUpdatingLocation()
        mapVIew.userTrackingMode = .follow
        mapVIew.showsUserLocation = true
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        mapVIew.removeAnnotations(mapVIew.annotations)
    }

    @IBAction func stopButtonAction(_ sender: Any) {
        self.stopButton.isEnabled = false
        self.startButton.isEnabled = true
        locManager.stopUpdatingLocation()
        mapVIew.userTrackingMode = .none
        mapVIew.showsUserLocation = false
    }
    
    var locManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.stopButton.isEnabled = false
        
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        
        self.addressLabel.text = ""
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        var n = 1.0
        if(location.speed.isLess(than: 10.0)) {
            n = 1.0
        } else if (location.speed.isLess(than: 30.0)) {
            n = 5.0
        } else if (location.speed.isLess(than: 50.0)) {
            n = 10.0
        } else {
            n = 25.0
        }
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01 * n, longitudeDelta: 0.01 * n))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation.title = "somt"
        mapVIew.addAnnotation(annotation)
        
        let xannotation = MyAnnotation(coordinate : center)
        self.mapVIew.addAnnotation(xannotation)
        self.mapVIew.userTrackingMode = .follow
        setAddress(location: location)
        self.mapVIew.setRegion(region, animated: true)
    }
    
    func setAddress(location : CLLocation) {
        geoCoder.reverseGeocodeLocation(location) {(placemarks,error) -> Void in
            var result = ""
            let array = placemarks as [CLPlacemark]!
            var placemark : CLPlacemark! = array?[0]
            result = "\(String(describing: placemark.postalCode!)) \(String(describing: placemark.locality!))"
            self.addressLabel.text = result
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

