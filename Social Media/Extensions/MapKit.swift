//
//  MapKit.swift
//  Social Media
//
//  Created by Philipp Lazarev on 13.08.2024.
//

import Foundation
import MapKit

extension MKMapView {
    func centerOnLocation(location: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self.setRegion(region, animated: true)
    }
}
