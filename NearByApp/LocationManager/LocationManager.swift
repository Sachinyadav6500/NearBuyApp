//
//  LocationManager.swift
//  NearByApp
//
//  Created by Sachin Yadav on 16/03/24.
//

import CoreLocation

//Note:- This class is used as Location Utility
//Implements Singleton Pattern to make sure we don't have multiple coreLocationManager Running

internal protocol LocationManagerProtocol: AnyObject {
    var delegate: LocationManagerResponseProtocol? { get set }
    func getCurrentLocation() -> (lat:Double,lng:Double)? // This to make sure sure not spreading Corelocation Everywhere
    func requestLocation()
}

protocol LocationManagerResponseProtocol: AnyObject {
    func locationUpdated()
    func locationUpdateFailed()
}

internal final class LocationManager: NSObject, LocationManagerProtocol {
        
    internal static var sharedInstance: LocationManagerProtocol = LocationManager()
    internal weak var delegate: LocationManagerResponseProtocol?
    
    fileprivate let locationUtility: CLLocationManager = CLLocationManager()
    fileprivate var location:CLLocationCoordinate2D?
    
    private override init() {
        super.init()
    }
    
    internal func getCurrentLocation() -> (lat:Double,lng:Double)? {
        
        if let loc = location {
            return (
                lat: loc.latitude,
                lng: loc.longitude
            )
        }
        return nil
    }
    
    internal func requestLocation() -> Void {
        self.locationUtility.delegate = self
        self.locationUtility.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationUtility.requestAlwaysAuthorization()
        self.locationUtility.requestWhenInUseAuthorization()
        self.locationUtility.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last?.coordinate
        self.delegate?.locationUpdated()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationUpdateFailed()
        print("Failed to get location: \(error)")
    }

}
