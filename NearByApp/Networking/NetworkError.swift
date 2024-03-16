//
//  NetworkError.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

/// Network Error enum
public enum NetworkError: Error {
    case networkError
    case noInternet
    case serverError
    case genericError(message: String)
}

