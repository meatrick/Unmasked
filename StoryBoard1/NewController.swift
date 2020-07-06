//
//  NewController.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 6/30/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit
import GooglePlaces

class NewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var POIName: UILabel!
    @IBOutlet weak var POIImage: UIImageView!
    @IBOutlet weak var POIAddress: UILabel!
    @IBOutlet weak var BusinessStatus: UILabel!
    
    var placeID: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient?
    var place: GMSPlace!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        // Update UI with POI info
        POIName.text = place.name
        POIAddress.text = place.formattedAddress
        
        // business status
        switch place.businessStatus.rawValue {
        case 1:
            BusinessStatus.text = "Operational"
            BusinessStatus.textColor = .green
        case 2:
            BusinessStatus.text = "Closed temporarily"
            BusinessStatus.textColor = .red
        case 3:
            BusinessStatus.text = "Closed permanently"
            BusinessStatus.textColor = .red
        case 0:
            BusinessStatus.text = "Operational status unknown"
            BusinessStatus.textColor = .gray
        default:
            BusinessStatus.text = "Operational Status Unknown"
        }
        
        
        
//        POIImage = place?.photos
        let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]

        // Call loadPlacePhoto to display the bitmap and attribution.
        self.placesClient?.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
          if let error = error {
            // TODO: Handle the error.
            print("Error loading photo metadata: \(error.localizedDescription)")
            return
          } else {
            // Display the first image and its attributions.
            self.POIImage?.image = photo;
//            self.lblText?.attributedText = photoMetadata.attributions;
          }
        })
    }
    
//    @IBAction func unwind(_ segue: UIStoryboardSegue) { }

}
