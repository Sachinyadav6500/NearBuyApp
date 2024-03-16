//
//  NearByPlaceTarget.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

enum NearByPlaceTarget {
    case getNearByPlace(requestData: NearByPlaceRequestModel)
}

extension NearByPlaceTarget: NetworkTarget {
    
    public var params: [String : Any]? {
        switch self {
        case .getNearByPlace:
            return [:]
        }
    }
    
    public var url: String {
        switch self {
        case let .getNearByPlace(data):
            
            return "https://api.seatgeek.com/2/venues?per_page=\(data.perPage)&page=\(data.page)&client_id=Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5&lat=\(data.lat)&lon=\(data.lon)&range=\(data.range)&q=\(data.query ?? "")"
        }
    }
    
    public var method: RequestMethod {
        .get
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getNearByPlace:
            return [:]
        }
    }
}
