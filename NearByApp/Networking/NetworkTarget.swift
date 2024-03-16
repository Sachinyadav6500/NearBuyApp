//
//  NetworkTarget.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

public protocol NetworkTarget {
    var url: String { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
    var timeout: Double { get }
}

public extension NetworkTarget {
    var timeout: Double {
        10
    }
}
