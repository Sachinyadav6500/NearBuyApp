//
//  NetworkProvider.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import Foundation

internal protocol NetworkProvidable {
    func executeRequest<T:Decodable>(
        networkTarget: NetworkTarget,
        modelType: T.Type,
        decoder: JSONDecoder,
        completion: @escaping (Result<T,NetworkError>)->Void)
}

internal final class NetworkProvider: NetworkProvidable {
    
    func executeRequest<T:Decodable>(
        networkTarget: NetworkTarget,
        modelType: T.Type,
        decoder: JSONDecoder,
        completion: @escaping (Result<T,NetworkError>)->Void) {
            guard let url = URL(string: networkTarget.url) else {
                completion(.failure(.genericError(message: "Invalid URL")))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = networkTarget.method.rawValue
            request.timeoutInterval = networkTarget.timeout
            
            if networkTarget.method != .get {
                // Check Becuase URL Session Give error if we don't have prams
                request.httpBody = try? JSONSerialization.data(withJSONObject: networkTarget.params ?? [:])
            }
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data {
                    do {
                        let apiResponse = try decoder.decode(modelType, from: data)
                        completion(.success(apiResponse))
                    } catch {
                        completion(.failure(.genericError(message: error.localizedDescription)))
                    }
                } else {
                    completion(.failure(.serverError))
                }
            }
            dataTask.resume()
        }
}
