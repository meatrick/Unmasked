//
//  ViewController.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 6/26/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    // marker is modified in didTapPOI func
    let infoMarker = GMSMarker()
    
    // for iPhone location
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    // POI data to pass to info page view controller
    var placeID: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    var placeToOpen: GMSPlace?
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {}
    
    
    // MARK: Scene Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewController
        {
//            print(placeID ?? "placeID not set in ViewController")
            vc.placeID = placeID
            vc.name = name
            vc.location = location
            vc.place = placeToOpen
            vc.placesClient = placesClient
            if placeToOpen == nil {
                print("property is nil")
            } else {
                print("prop not nil")
            }
        }
    }
    
    
    // MARK: View Loading Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//        self.view.addSubview(mapView)
        
        
//      location services
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        
//      Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // search bar button
        makeButton()
}

    
    override func loadView() {
      let camera = GMSCameraPosition.camera(withLatitude: 47.603, longitude:-122.331, zoom:14)
      mapView = GMSMapView.map(withFrame: .zero, camera: camera)
      mapView.delegate = self
      self.view = mapView
    }
    
    // MARK: Tap Events
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
      print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        
        // update class properties for navigation
        self.placeID = placeID
        self.name = name
        self.location = location
        
        getPlaceInfoFromID(placeID: placeID)
        
        
        
    }
    
    
    
    // MARK: User Location

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13.0)

//      // This is where the blue dot is updated
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
//        self.view = mapView
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        locationManager.stopUpdatingLocation()
      }

      // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
          print("Location access was restricted.")
        case .denied:
          print("User denied access to location.")
          // Display the map using the default location.
          mapView.isHidden = false
        case .notDetermined:
          print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
          print("Location status is OK.")
        @unknown default:
          fatalError()
        }
      }

      // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
      }

    
    
    // MARK: Places API
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked(_ sender: UIButton) {
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self

      // Specify the place data types to return.
      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.placeID.rawValue))!
      autocompleteController.placeFields = fields

      // Specify a filter.
//      let filter = GMSAutocompleteFilter()
//      filter.type = .address
//      autocompleteController.autocompleteFilter = filter

      // Display the autocomplete view controller.
      present(autocompleteController, animated: true, completion: nil)
    }


    // MARK: Search button
    func makeButton() {
        let btnLaunchAc = UIButton(type: .roundedRect)
        btnLaunchAc.backgroundColor = .systemBackground
        btnLaunchAc.setTitle("Search...", for: .normal)
        btnLaunchAc.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
        
        //Add padding around text
        btnLaunchAc.titleEdgeInsets = UIEdgeInsets(top: -10,left: -10,bottom: -10,right: -10)
        btnLaunchAc.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        self.view.addSubview(btnLaunchAc)
        
        //Button Constraints:
        btnLaunchAc.translatesAutoresizingMaskIntoConstraints = false

        //To anchor above the tab bar on the bottom of the screen:
        let bottomButtonConstraint = btnLaunchAc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 5)

        //edge of the screen in InterfaceBuilder:
        let margins = view.layoutMarginsGuide
        let leadingButtonConstraint = btnLaunchAc.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        let trailingButtonConstraint = btnLaunchAc.trailingAnchor.constraint(equalTo: margins.trailingAnchor)

        bottomButtonConstraint.isActive = true
        leadingButtonConstraint.isActive = true
        trailingButtonConstraint.isActive = true
        
    }
    
    
}


// MARK: Search Auto-complete
extension ViewController: GMSAutocompleteViewControllerDelegate {

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // debugging info
        let errorStr = NSAttributedString(string: "Error")
        print("Place name: \(place.name ?? "Error")")
        print("Place ID: \(place.placeID ?? "Error")")
        print("Place attributions: \(place.attributions ?? errorStr)")
        dismiss(animated: true, completion: nil)
        
        // move the camera to the selected place
        moveCameraToPlace(placeId: place.placeID)
        
        // TODO: automatically open information panel for selected business
        
        // update class properties for scene navigation
        self.placeID = place.placeID
        self.name = place.name
        
        // TODO: call function to perform segue from "ViewController"
//        performSegue(withIdentifier: "showInfoPage", sender: nil)
        
        // get place information, set it to placeToOpen, so it can be sent to other VC
//        getPlaceInfoFromID(placeID: place.placeID)

    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // TODO: these functions are depreceted.  Replace or remove
    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }

    // MARK: move camera after search
    func moveCameraToPlace(placeId: String?) {
        // Field: coordinate
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue))!

        placesClient?.fetchPlace(fromPlaceID: placeId!, placeFields: fields, sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                // move camera to place
//                mapView.animate(toLocation: place.coordinate)
                let camera = GMSCameraPosition.init(target: place.coordinate, zoom: 20)
                self.mapView.camera = camera
            }
        })
    }
    
    // MARK: get Place info from placeID
    // automatically gets the GMSPlace object and sets it to the class property
    func getPlaceInfoFromID(placeID: String!) {
        // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue) | UInt(GMSPlaceField.name.rawValue))!

        placesClient?.fetchPlace(fromPlaceID: placeID,
                                 placeFields: fields,
                                 sessionToken: nil, callback: {
          (place: GMSPlace?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }
          if let place = place {
            // pass the information on to the infoVC
            self.placeToOpen = place
            print(place.name ?? "place no name")
            // Use segue to do transition
            self.performSegue(withIdentifier: "showInfoPage", sender: nil)
          }
        })
    }
}


