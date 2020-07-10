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
    @IBOutlet weak var reviewStack: UIStackView!
    @IBOutlet weak var review0: Review!
    @IBOutlet weak var review1: Review!
    @IBOutlet weak var review2: Review!
    
    
    var placeID: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient?
    var place: GMSPlace!
    
    
    // MARK: Actions
    @IBAction func btnWriteReview(_ sender: Any) {
        print("SHOW THE SEGUE")
        // segue to ReviewController
        performSegue(withIdentifier: "showReviewController", sender: nil)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // MARK: display text
        
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
        
        // MARK: get photo
        
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
        
        
        // MARK: get reviews
        
        // get reviews from firebase by passing in placeID
        // returns a list of reviews
        // for up to 3 reviews, create a ReviewView, populate the data, and display it
//        let review0 = Review()
//        let review1 = Review()
//        let review2 = Review()
        review0.reviewText.text = "good"
        review1.reviewText.text = "bad"
        review2.reviewText.text = "okay"
        
        // constraints


//        reviewStack.addArrangedSubview(review0)
//        reviewStack.addArrangedSubview(review1)
//        reviewStack.addArrangedSubview(review2)
//        
        
    }
    
}

