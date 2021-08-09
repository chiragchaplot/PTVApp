//
//  ResponseHandler+Extension.swift
//  PTVApp
//
//  Created by Chirag Chaplot on 8/8/21.
//

import Foundation

extension ResponseHandler {
    func defaultParseResponse<T: Codable>(data: Data, response: HTTPURLResponse) throws -> T {
        let jsonDecoder = JSONDecoder()
        do {
            let body = try jsonDecoder.decode(T.self, from: data)
            if response.statusCode == 200 {
                return body
            } else {
                throw ServiceError(httpStatus: response.statusCode, message: "Unknown Error")
            }
        }  catch let DecodingError.dataCorrupted(context) {
                print("# Data corrupted: ", context.debugDescription)
                print(context)
            throw ServiceError(httpStatus: response.statusCode, message: "# Data corrupted: " + context.debugDescription)
            } catch let DecodingError.keyNotFound(key, context) {
                print("# Key '\(key)' not found:", context.debugDescription)
                print("# CodingPath:", context.codingPath)
                throw ServiceError(httpStatus: response.statusCode, message: "# CodingPath: " + context.debugDescription)
            } catch let DecodingError.valueNotFound(value, context) {
                print("# Value '\(value)' not found:", context.debugDescription)
                print("# CodingPath:", context.codingPath)
                throw ServiceError(httpStatus: response.statusCode, message: "# CodingPath: " + context.debugDescription)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("# Type '\(type)' mismatch:", context.debugDescription)
                print("# CodingPath:", context.codingPath)
                throw ServiceError(httpStatus: response.statusCode, message: "# CodingPath: " + context.debugDescription)
            } catch  {
                throw ServiceError(httpStatus: response.statusCode, message: error.localizedDescription)
            }
        
    }
}

enum NetworkResponseError: String, Error {
    case decodingDataCorrupted = "Decoding Error: Data corruoted."
    case decodingKeyNotFound = "Decoding Error: Decoding key not found"
    case decodingValueNotFound = "Decoding Error: Decoding value not found"
    case decodingTypeMismatch = "Decoding Error: Type mismatch"
}

struct ServiceError: Error,Codable {
    let httpStatus: Int
    let message: String
}
