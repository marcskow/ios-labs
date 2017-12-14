//
//  MyAnnotation.swift
//  MapZadanie3
//
//  Created by Marcin Skowron on 27/11/2017.
//  Copyright © 2017 Marcin Skowron. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MyAnnotation : NSObject,MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate : CLLocationCoordinate2D) {
        self.coordinate = coordinate;
        super.init()
    }
}
