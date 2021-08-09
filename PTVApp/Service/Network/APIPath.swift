//
//  APIPath.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 8/8/21.
//

import Foundation
import CommonCrypto

#if DEBUG
let environment = APIEnvironment.development
#else
let environment = APIEnvironment.development
#endif

let baseURL = environment.baseURL()

struct APIPath {
        
    var routeType: String {
        return "\(baseURL)route_types/"
    }
    
//http://timetableapi.ptv.vic.gov.au/v3/stops/location/144.89966,-37.80347?max_results=30&max_distance=300&stop_disruptions=false&devid=3001964&signature=ACB822A7B8604CB1AFD847111FCACAF20D36DA5D

    func getStopsAroundLocation(long: Double, lat: Double) -> String {
        var query = "\(baseURL)stops/location/\(lat),\(long)?max_results=30&max_distance=300&stop_disruptions=false&devid=" + APIEnvironment.development.userID()
        let signature = generateSignature(query)
        query = query + "&signature=" + signature
        return query
    }
    
    func generateSignature(_ callURL: String) -> String {
        let queryString = String(callURL.dropFirst("https://timetableapi.ptv.vic.gov.au".count))
        var signature = ""
        signature = queryString.hmac(key: APIEnvironment.development.developerKey())
        return signature.uppercased()
    }
}
