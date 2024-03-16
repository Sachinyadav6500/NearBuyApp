//
//  NearByPlaceRequestModel.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

struct NearByPlaceRequestModel: Codable {
    internal var perPage: Int = 10
    internal var page: Int = 1
    internal var lat: String = "12.6"
    internal var lon: String = "78.45"
    internal var range: String = "100mi"
    internal var query: String?
}
