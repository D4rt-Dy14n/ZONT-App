//
//  LocationServiceDelegate.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 01.11.2024.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationService(_ service: LocationServiceProtocol, didUpdateLocations locations: [CLLocation])
    func locationService(_ service: LocationServiceProtocol, didFailWithError error: Error)
    func locationServiceDidChangeAuthorization(_ service: LocationServiceProtocol)
}
