//
//  NewController.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 6/30/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseAuth

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
    @IBOutlet weak var displayedRatingNum: UILabel!
    @IBOutlet weak var displayedStars: StarRatingView!
    @IBOutlet weak var displayedNumReviews: UILabel!
    @IBOutlet weak var starsOverall: StarRatingView!
    @IBOutlet weak var starsCat1: StarRatingView!
    @IBOutlet weak var starsCat2: StarRatingView!
    @IBOutlet weak var starsCat3: StarRatingView!
    @IBOutlet weak var starsCat4: StarRatingView!
    
    
    var placeID: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient?
    var place: GMSPlace!
    
    // Firebase Auth
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    
    
    // MARK: Actions
    @IBAction func btnWriteReview(_ sender: Any) {
        if user != nil {
            // segue to ReviewController
            performSegue(withIdentifier: "showReviewController", sender: nil)
        } else {
            alertNotSignedIn()
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {}
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.user = user
        }
    }
    
    // TODO: add viewWillDisappear func
    
    // MARK: Alert
    func alertNotSignedIn() {
        let defaultAction = UIAlertAction(title:
            "Ok", style: .default) { (action) in
        }
        
        let alert = UIAlertController(title: "Not Signed In",
              message: "You must be signed in to leave a review",
              preferredStyle: .alert)
        alert.addAction(defaultAction)
        
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
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

