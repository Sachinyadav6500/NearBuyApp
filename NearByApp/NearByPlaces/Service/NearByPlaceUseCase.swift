//
//  NearByPlaceUseCase.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

internal protocol NearByPlaceUseCaseType: AnyObject {
    func getNearByVeneues(requestModel: NearByPlaceRequestModel,
                                 completionHandler: @escaping (Result<NearByPlacesResponseModel, NetworkError>)->Void)
}

internal final class NearByPlaceUseCase: NearByPlaceUseCaseType {
    private let networkProvider: NetworkProvidable
    
    init(networkProvider: NetworkProvidable = NetworkProvider()) {
        self.networkProvider = networkProvider
    }

    func getNearByVeneues(requestModel: NearByPlaceRequestModel,
                          completionHandler: @escaping (Result<NearByPlacesResponseModel, NetworkError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        networkProvider.executeRequest(
            networkTarget: NearByPlaceTarget.getNearByPlace(requestData: requestModel),
            modelType: NearByPlacesResponseModel.self,
            decoder: jsonDecoder,
            completion: { response in
                completionHandler(response)
            })
    }
}
