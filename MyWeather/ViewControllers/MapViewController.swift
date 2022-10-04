//
//  MapViewController.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 22.09.2022.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

protocol MapVCDelegate: class {
    func resetLocationDetailInFirstVC(massage: String)
}

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    // MARK: - Constants and Variables
    private let map: MKMapView = {
        let value = MKMapView()
        value.clipsToBounds = true
        value.layer.cornerRadius = 30
        return value
    }()

    private let checkWeatherByLocationButton: UIButton = {
        let value = UIButton()
        value.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        value.clipsToBounds = true
        value.layer.cornerRadius = 5
        value.backgroundColor = UIColor(red: 181/255, green: 213/255, blue: 248/255, alpha: 0.75)
        value.setBackgroundImage(#imageLiteral(resourceName: "checkLocation"), for: .normal)
        value.addTarget(self, action: #selector(pickLocation), for: .touchUpInside)
        value.imageView?.contentMode = .scaleAspectFit
        return value
    }()

    var lat = Double()
    var long = Double()

    private let defaults = UserDefaults.standard
    var coordinate = CLLocationCoordinate2D()
    var coordinates = [CLLocationCoordinate2D]()
    
    var delegate: MapVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Weather by location"
        configureUI()
        configureMap()

        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(lpgrPressed))
            longPressGR.minimumPressDuration = 0.5
            longPressGR.delaysTouchesBegan = true
            longPressGR.delegate = self
            self.map.addGestureRecognizer(longPressGR)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - functions
    @objc func pickLocation(_ sender: Any?) {
        print("New location picked: \(String(describing: coordinates.last ?? coordinate))")
        // set new lat and long parametr
        lat = coordinates.last?.latitude ?? coordinate.latitude
        long = coordinates.last?.longitude ?? coordinate.longitude

        delegate?.resetLocationDetailInFirstVC(massage: "New location sent thrue delegate - lat:\(lat) + long:\(long)")
            self.dismiss(animated: true)
    }

    @objc func lpgrPressed(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: map)
            let locationCoordinate = map.convert(touchLocation, toCoordinateFrom: map)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            coordinates.append(locationCoordinate)

            map.setRegion(
                MKCoordinateRegion(
                    center: coordinates.last ?? coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.1,
                        longitudeDelta: 0.1)),
                animated: true)

            map.removeAnnotations(map.annotations)
            addCustomPin()
            coordinates.removeFirst()
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }

    private func configureMap() {
        lat = defaults.double(forKey: "lat")
        long = defaults.double(forKey: "long")
        coordinate.latitude = lat
        coordinate.longitude = long
        coordinates.append(coordinate)

        map.setRegion(
            MKCoordinateRegion(
                center: coordinates.last ?? coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.1,
                    longitudeDelta: 0.1)),
            animated: true)

        map.delegate = self

        addCustomPin()
    }

    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates.last ?? coordinate
        pin.title = "Location picked"
        pin.subtitle = "Tap button to know what's the weather"
        map.addAnnotation(pin)
    }

    private func configureUI() {
        view.addSubview(map)
        map.snp.makeConstraints {
            $0.width.equalToSuperview().inset(30)
            $0.height.equalTo(view.frame.size.height / 1.2)
            $0.centerX.centerY.equalToSuperview()
        }
        view.backgroundColor = UIColor(red: 181/255, green: 213/255, blue: 248/255, alpha: 0.75)
    }

    // Map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "customPin")
        if annotationView == nil {
            // create the view
            annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: "customPin")
            annotationView?.canShowCallout = true
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
            annotationView?.rightCalloutAccessoryView = checkWeatherByLocationButton
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = UIImage(named: "weatherLocation")
        return annotationView
    }
}
