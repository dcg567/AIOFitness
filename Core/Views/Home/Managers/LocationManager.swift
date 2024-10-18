//
//  LocationManager.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 18/01/2024.
//
//  Some code segments have been sourced from third parties

import Foundation
import CoreLocation

// Protocol defining the necessary functionalities of a location service
protocol LocationService {
    func requestLocation()
    func requestWhenInUseAuthorization()
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
}

// Conforming CLLocationManager to the LocationService protocol
extension CLLocationManager: LocationService {}

// Possible error states related to location services
enum LocationError: Error {
    case authorizationDenied
    case authorizationRestricted
    case failedToReceiveLocation
    case unknownError
}

// Class to manage location fetching that observes changes and publishes updates
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationService: LocationService
    // Published properties that can be observed by SwiftUI Views or other components
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var error: LocationError?
    
    // Stores the timestamp of the last location update
    private var lastLocationUpdate: Date?
    
    // Sets up the manager with default values
    init(locationService: LocationService = CLLocationManager(), desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) {
        self.locationService = locationService
        super.init()
        self.locationService.delegate = self
        self.locationService.desiredAccuracy = desiredAccuracy
    }
    
    // Starts the process of getting the location.
    func requestLocation() {
        isLoading = true
        locationService.requestWhenInUseAuthorization()
        locationService.requestLocation()
    }
    
    // Method that handles successful location updates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else { return }
        
        let now = Date()
        if let lastUpdate = lastLocationUpdate, now.timeIntervalSince(lastUpdate) < 5 {
            // Ignore updates that are too frequent
            return
        }
        
        lastLocationUpdate = now
        location = newLocation.coordinate
        isLoading = false
    }
    
    // Method that handles errors during location updates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
        self.error = .failedToReceiveLocation
        isLoading = false
    }
    
    // This decides what to do when the app is or isn't allowed to get the location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .denied:
            self.error = .authorizationDenied
            isLoading = false
        case .restricted:
            self.error = .authorizationRestricted
            isLoading = false
        case .notDetermined:
            locationService.requestWhenInUseAuthorization()
        @unknown default:
            self.error = .unknownError
            fatalError("Unhandled authorization status: \(status)")
        }
    }
}
