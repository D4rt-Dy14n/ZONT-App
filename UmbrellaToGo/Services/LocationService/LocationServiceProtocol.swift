//
//  LocaionProtocol.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 01.11.2024.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol: AnyObject {
    var delegate: LocationServiceDelegate? { get set }
    var location: CLLocation? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}
