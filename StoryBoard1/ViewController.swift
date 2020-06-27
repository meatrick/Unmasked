//
//  ViewController.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 6/26/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate {
    
    // marker is modified in mapView func
    let infoMarker = GMSMarker()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

    override func loadView() {
      let camera = GMSCameraPosition.camera(withLatitude: 47.603,
                                            longitude:-122.331,
                                            zoom:14)
      let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
      mapView.delegate = self
      self.view = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
//      print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
    }

}

