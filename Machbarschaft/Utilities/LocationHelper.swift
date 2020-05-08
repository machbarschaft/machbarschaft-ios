//
//  LocationHelper.swift
//  Machbarschaft
//
//  Created by Manuel Donaubauer on 08.05.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import CoreLocation
import PromiseKit

class LocationHelper: NSObject {
    
    let locationManager = CLLocationManager()
    var locationResolver: Resolver<CLPlacemark>?
    
    func getCurrentLocation() -> Promise<CLPlacemark> {
        return Promise { resolver in
            self.setupLocationManager()
            self.locationResolver = resolver
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            debugPrint("LoginStep3ViewController locationManager location is nil")
            self.locationResolver?.reject(LocationHelperErrors.locationIsNil)
            self.locationResolver = nil
            return
        }
        CLGeocoder().reverseGeocodeLocation(location) { optionalPlaces, optionalError -> Void in
            if let error = optionalError {
                debugPrint("LoginStep3ViewController locationManager error: \(error.localizedDescription)")
                self.locationResolver?.reject(LocationHelperErrors.clError(clErrorDescription: error.localizedDescription, errorCode: error._code))
                self.locationResolver = nil
                return
            }
            guard let places = optionalPlaces, let firstPlace = places.first else {
                debugPrint("LoginStep3ViewController locationManager no places found")
                self.locationResolver?.reject(LocationHelperErrors.noPlacesFound)
                self.locationResolver = nil
                return
            }
            self.locationManager.stopUpdatingLocation()
            self.locationResolver?.fulfill(firstPlace)
            self.locationResolver = nil
        }
    }
}
