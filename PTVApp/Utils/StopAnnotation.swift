//
//  StopAnnotation.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 9/8/21.
//

import Foundation
import MapKit

final class StopAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(stopLong: Double, stopLat: Double, title: String, subtitle: String) {
        self.coordinate = CLLocationCoordinate2D(latitude: stopLat, longitude: stopLong)
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
