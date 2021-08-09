//
//  APIEnvironment.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 8/8/21.
//

import Foundation

enum APIEnvironment {
    case development
    case staging
    case production
    
    func baseURL () -> String {
        return domain()
    }
    
    func domain() -> String {
        switch self {
        case .development:
            return "https://timetableapi.ptv.vic.gov.au/v3/"
        case .staging:
            return "https://timetableapi.ptv.vic.gov.au/v3/"
        case .production:
            return "https://timetableapi.ptv.vic.gov.au/v3/"
        }
    }
    
    func userID () -> String {
        switch self {
        case .development:
            return "3001964"
        case .staging:
            return "3001964"
        case .production:
            return "3001964"
        }
    }
    
    func developerKey () -> String  {
        switch self {
        case .development:
            return "2c40e7d6-0954-47fa-b998-6fe17eaf538b"
        case .staging:
            return "2c40e7d6-0954-47fa-b998-6fe17eaf538b"
        case .production:
            return "2c40e7d6-0954-47fa-b998-6fe17eaf538b"
        }
    }
}
