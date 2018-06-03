//
//  LocationService.swift
//  TripGallery


import Foundation
import MapKit
import UIKit

protocol LocationObserver {
    func locationDidChange(newLocations : [CLLocation])
    
}

class LocationService: NSObject,CLLocationManagerDelegate {
    
    var locationObservers : [LocationObserver] = []
    var locationManager = CLLocationManager.init()
    static let shared: LocationService = LocationService()
    
    override private init(){
        super.init()
        locationManager.desiredAccuracy = 100
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func registerLocationObserver(locationObserver :LocationObserver)
    {
        locationObservers.append(locationObserver)
    }
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation])
    {
        
        for observer in locationObservers{
            observer.locationDidChange(newLocations: locations)
        }
    }
}
