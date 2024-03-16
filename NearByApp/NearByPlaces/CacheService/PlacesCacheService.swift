//
//  PlacesCacheService.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

internal protocol PlacesCacheServiceType: AnyObject {
    func savePlacesData(data: [PlaceResponseModel])
    func fetchSavedPlacesData(complition: @escaping ([PlaceResponseModel]) -> Void)
}


final internal class PlacesCacheService: PlacesCacheServiceType {
    func savePlacesData(data: [PlaceResponseModel]) {
        // TODO: Pending
        //we can use core Data or local file storage here that is abstracted from viewModel we can change implementation whenever we wanted
    }
    
    func fetchSavedPlacesData(complition: @escaping ([PlaceResponseModel]) -> Void) {
        // TODO: Pending
    }
    
    
}
