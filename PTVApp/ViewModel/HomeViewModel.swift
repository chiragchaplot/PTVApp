//
//  HomeViewModel.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 8/8/21.
//

import Foundation
import MapKit
import os

class HomeViewModel {
    var request : GetStopsAPI
    var apiLoader : APILoader<GetStopsAPI>
    
    
    init() {
        request = GetStopsAPI()
        apiLoader = APILoader<GetStopsAPI>(apiHandler: request)
    }
    
    func getStops(long: Double, lat: Double) {
        print(long)
        print(lat)
    }
    
    func fetchStopsAroundLocation(param: [String: Any], completion: @escaping (StopsAroundLocation?, ServiceError?) -> ()) {
        apiLoader.loadAPIRequest(requestData: param) {
            (model, error) in
            if let _ = error {
                completion(nil, error)
            } else {
                completion(model, nil)
            }
        }
    }
    
    func returnAnnotations(stopAroundLocation: StopsAroundLocation) -> [StopAnnotation] {
        var stopAnnotations = [StopAnnotation]()
        for stop in stopAroundLocation.stops {
            //Create an annotation
            let stopMarker = StopAnnotation(stopLong: stop.stopLongitude, stopLat: stop.stopLatitude, title: stop.stopName, subtitle: "Routes: " + String(stop.routes.count), stopType: stop.routes.count)
            stopAnnotations.append(stopMarker)
        }
        return stopAnnotations
    }
}
