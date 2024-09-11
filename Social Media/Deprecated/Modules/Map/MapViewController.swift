//
//  MapViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.07.2024.
//

/*
 
 FOLLOWING CODE IS DEPRECATED AND IS NOT USED IN LATEST APP VERSIONS
 
 */

/*
import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var annotations = [MKPointAnnotation]()
    var overlays = [MKPolyline]()
    
    // MARK: - Subviews
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))

        mapView.addGestureRecognizer(longPressRecognizer)
        
        return mapView
    }()
    
    private lazy var makeRouteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        
        button.setImage(UIImage(systemName: "arrow.triangle.swap"), for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(makeRouteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeLastPointButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true

        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10

        button.addTarget(self, action: #selector(removeLastPointButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeAllPointsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true

        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.2.fill"), for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(removeAllPointsButtonTapped), for: .touchUpInside)

        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
        setupDelegates()
    }
    
    
    // MARK: - Actions
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            annotation.title = String(localized: "Location \(annotations.count + 1)")
            annotation.subtitle = String(localized: "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
            
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
    }
    
    @objc func makeRouteButtonTapped(_ sender: UIButton) {

        guard let userLocation = locationManager.location?.coordinate else {
            let title = String(localized: "Error!")
            self.showAlert(title: title, description: String(localized: "No access to user location!"))
            return
        }
        
        var locations = [CLLocationCoordinate2D]()
        locations.append(userLocation)
        locations.append(contentsOf: annotations.map { $0.coordinate })
        
        for i in 0..<locations.count - 1 {
            let sourceCoordinate = locations[i]
            let destinationCoordinate = locations[i + 1]
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .walking
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let response = response else {
                    if let error = error {
                        let title = String(localized: "Error!")
                        self.showAlert(title: title, description: String(localized: "Error calculating directions: \(error.localizedDescription)"))
                    }
                    return
                }
                
                let route = response.routes[0]
                self.overlays.append(route.polyline)
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
            }
        }
    }
    
    @objc func removeLastPointButtonTapped(_ sender: UIButton) {
        if let removedAnnotation = annotations.last {
            mapView.removeAnnotation(removedAnnotation)
            annotations.removeLast()
        }
        
        if let removedOverlay = overlays.last {
            mapView.removeOverlay(removedOverlay)
            overlays.removeLast()
        }
    }
    
    @objc func removeAllPointsButtonTapped(_ sender: UIButton) {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        overlays.removeAll()
    }
    
    // MARK: - Private
    private func setupUI() {
        view.backgroundColor = .systemBackground
        mapView.showsUserLocation = true
        
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            print("notDetermined")
            locationManager.requestWhenInUseAuthorization()
            let newStatus = locationManager.authorizationStatus
            if newStatus == .authorizedWhenInUse || newStatus == .authorizedAlways {
                if let location = locationManager.location {
                    mapView.centerOnLocation(location: location)
                }
            }
            
        case .restricted, .denied:
            print("Access denied")
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                mapView.centerOnLocation(location: location)
            }
            
        @unknown default:
            fatalError("Unhandled case in CLLocationManager.authorizationStatus()")
        }
    }
    
    private func addSubviews() {
        view.addSubview(mapView)
        
        mapView.addSubview(makeRouteButton)
        mapView.addSubview(removeLastPointButton)
        mapView.addSubview(removeAllPointsButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            makeRouteButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            makeRouteButton.heightAnchor.constraint(equalToConstant: 50),
            makeRouteButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 5),
            makeRouteButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            removeLastPointButton.topAnchor.constraint(equalTo: makeRouteButton.bottomAnchor, constant: 10),
            removeLastPointButton.heightAnchor.constraint(equalToConstant: 50),
            removeLastPointButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 5),
            removeLastPointButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            removeAllPointsButton.topAnchor.constraint(equalTo: removeLastPointButton.bottomAnchor, constant: 10),
            removeAllPointsButton.heightAnchor.constraint(equalToConstant: 50),
            removeAllPointsButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 5),
            removeAllPointsButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupDelegates() {
        mapView.delegate = self
        locationManager.delegate = self
    }
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer()
    }
}
*/
