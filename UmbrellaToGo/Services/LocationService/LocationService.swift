//
//  LocationService.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 01.11.2024.
//

import Foundation
import CoreLocation

final class LocationService: NSObject, LocationServiceProtocol {
    weak var delegate: LocationServiceDelegate?
    private let locationManager = CLLocationManager()

    var location: CLLocation? {
        return locationManager.location
    }

    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 1000
    }

    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.locationServiceDidChangeAuthorization(self)

        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationService(self, didUpdateLocations: locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationService(self, didFailWithError: error)
    }
}
