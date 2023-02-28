//
//  LocationManager.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 04.11.2022.
//

import UIKit
import CoreLocation

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
}

class LocationManager: NSObject {
    static let shared = LocationManager()

    public func findLocations(with query: String, completion: @escaping(([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }

            let models: [Location] = places.compactMap({ place in
                var name = ""

                if let locationName = place.name {
                    name += locationName
                }

                if let adminArea = place.administrativeArea {
                    name += ", \(adminArea)"
                }

                if let locality = place.locality {
                    name += ", \(locality)"
                }

                if let country = place.country {
                    name += ", \(country)"
                }

                print("\n 🏠\(place) ")

                let result = Location(title: name, coordinates: place.location?.coordinate)
                return result
            })
            completion(models)
        }
    }

    public func findLocationsByCoordinates(lat: Double, lon: Double, completion: @escaping(([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap({ place in
                var name = ""
                
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminArea = place.administrativeArea {
                    name += ", \(adminArea)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                print("\n 🏠\(place) by coordinate ")
                
                let result = Location(title: name, coordinates: place.location?.coordinate)
                return result
            })
            completion(models)
        })
    }
}
