//
//  NearByPlacesResponseModel.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

internal struct NearByPlacesResponseModel: Decodable {
    internal let venues: [PlaceResponseModel]?
    internal let meta: MetaResponseModel?
}

// MARK: - Meta
internal struct MetaResponseModel: Codable {
    internal let total, took, page, perPage: Int?

    enum CodingKeys: String, CodingKey {
        case total, took, page
        case perPage = "per_page"
    }
}

// MARK: - PlaceResponseModel
internal struct PlaceResponseModel: Codable {
    internal let state: String?
    internal let nameV2, postalCode, name: String?
    internal let timezone: String?
    internal let url: String?
    internal let address: String?
    internal let country: String?
    internal let hasUpcomingEvents: Bool?
    internal let numUpcomingEvents: Int?
    internal let id, popularity: Int?
}
