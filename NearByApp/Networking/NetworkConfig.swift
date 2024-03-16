//
//  NetworkConfig.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
}

public enum HTTPStatusCode: Int {
    case ok = 200
    case requestTimeout = 408
    case tooManyRequests = 429
    case internalServerError = 500
    case unknownError = -1_001_001
    case noInternet = -1009
    case unauthorized = 401
}
