//
//  RequestHandler+Extension.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 8/8/21.
//

import Foundation

extension RequestHandler {
    
    func setQueryParams(parameters:[String: Any], url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.map { element in URLQueryItem(name: element.key, value: String(describing: element.value) ) }
        return components?.url ?? url
    }
    
    func setDefaultHeaders(request: inout URLRequest) {
        request.setValue(URLConstants.contentTypeValue, forHTTPHeaderField: URLConstants.kContentType)
        request.setValue(URLConstants.xvValue, forHTTPHeaderField: URLConstants.kXV)
    }
}

