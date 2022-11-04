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

protocol MapVCPickedLocationDelegate: AnyObject {
    func mapPickedLocation(lat: Double, long: Double)
}

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    // MARK: - Constants and Variables
    private let map: MKMapView = {
        let value = MKMapView()
        value.clipsToBounds = true
        return value
    }()

    private let mapSearchVC = MapSearchVC()

    private let checkWeatherByLocationButton: UIButton = {
        let value = UIButton()
        value.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        value.setBackgroundImage(#imageLiteral(resourceName: "checkLocation"), for: .normal)
        value.addTarget(self, action: #selector(pickLocation), for: .touchUpInside)
        value.imageView?.contentMode = .scaleAspectFit
        return value
    }()

    private var lat = Double()
    private var long = Double()

    private let defaults = UserDefaults.standard
    private var coordinate = CLLocationCoordinate2D()
    private var coordinates = [CLLocationCoordinate2D]()

    weak var delegate: MapVCPickedLocationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLongPress()
        configureUI()
        configureMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - functions
    private func initLongPress() {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(lpgrPressed))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        longPressGR.delegate = self
        self.map.addGestureRecognizer(longPressGR)
    }

    private func configureUI() {
        view.addSubview(map)
        configureNavigationBar()

        map.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureNavigationBar() {
        title = "Pick location"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonePressed)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.uturn.left"),
            style: .plain,
            target: self,
            action: #selector(dissmissAction)
        )

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }

    @objc func dissmissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @objc func searchButtonePressed(_ sender: Any) {
        mapSearchVC.delegate = self
        if let sheet = mapSearchVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }

        present(mapSearchVC, animated: true)
    }

    // MARK: - Map configuration
    // Configure UILongPressGestureRecognizer
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
                        latitudeDelta: 0.5,
                        longitudeDelta: 0.5)),
                animated: true)

            map.removeAnnotations(map.annotations)
            addCustomPin()
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }

    // Configure cusom Pin
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates.last ?? coordinate
        pin.title = "Location picked"
        pin.subtitle = "Tap button to know what's the weather"
        map.addAnnotation(pin)
    }

    // Passing new weather location to MainVC
    @objc func pickLocation(_ sender: Any?) {
        print("New location picked: \(String(describing: coordinates.last ?? coordinate))")
        // set new lat and long parametr
        lat = coordinates.last?.latitude ?? coordinate.latitude
        long = coordinates.last?.longitude ?? coordinate.longitude

        self.delegate?.mapPickedLocation(lat: lat, long: long)
            self.dismiss(animated: true)
    }

// Configure map appearance
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
                    latitudeDelta: 0.5,
                    longitudeDelta: 0.5)),
            animated: true)

        map.delegate = self
        addCustomPin()
    }

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

extension MapViewController: MapSearchDelegate {
    func mapSearchVCLocationPicked(_ vc: MapSearchVC, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {

        guard let coordinates = coordinates else {
            return
        }

        map.removeAnnotations(map.annotations)
        self.coordinates.append(coordinates)
        addCustomPin()

        mapSearchVC.dismiss(animated: true)

        map.setRegion(MKCoordinateRegion(
            center: coordinates,
            span: MKCoordinateSpan(
                latitudeDelta: 0.5,
                longitudeDelta: 0.5)
        ),
                      animated: true
        )
    }
}
