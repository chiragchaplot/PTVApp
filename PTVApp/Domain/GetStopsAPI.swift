//
//  GetStopsAPI.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 9/8/21.
//

import Foundation

class GetStopsAPI: APIHandler {
    //    //http://timetableapi.ptv.vic.gov.au/v3/stops/location/-37.803470,144.899660?max_distance=500&devid=3001964&signature=2A62EED3E678580C0744FE2160EDCF198C1E9273
    func makeRequest(from param: [String: Any]) -> URLRequest? {
        if let long = param["long"] as? Double, let lat = param["lat"] as? Double {
            
            let urlString =  APIPath().getStopsAroundLocation(long: long, lat: lat)
            print(urlString)
            if let url = URL(string: urlString) {
//                if params.count > 0 {
//                    url = setQueryParams(parameters: params, url: url)
//                }
                var urlRequest = URLRequest(url: url)
                setDefaultHeaders(request: &urlRequest)
                urlRequest.httpMethod = HTTPMethod.get.rawValue
                print(urlRequest.url?.absoluteString)
                return urlRequest
            }
        }
        return nil
    }
    
    func parseResponse(data: Data, response: HTTPURLResponse) throws -> StopsAroundLocation {
        return try defaultParseResponse(data: data,response: response)
    }
}
