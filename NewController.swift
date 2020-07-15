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
import Firebase

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
    @IBOutlet weak var btnWriteReview: UIButton!
    
    
    var placeID: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient?
    var place: GMSPlace!
    
    // Firebase Auth
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    var db: Firestore!
    
    var textReviews: [String?] = []
    
    
    // MARK: Actions
    @IBAction func btnWriteReview(_ sender: Any) {
        if user != nil {
            // segue to ReviewController
            performSegue(withIdentifier: "showReviewController", sender: nil)
        } else {
            alertNotSignedIn()
        }
    }
    
    @IBAction func btnSeeReviews(_ sender: Any) {
        performSegue(withIdentifier: "showAllReviewsController", sender: nil)
    }
    // MARK: Sign Out
//    @IBAction func signOut(_ sender: Any) {
//        do {
//            try Auth.auth().signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.user = user
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ReviewController {
            vc.placeID = placeID
            vc.placeName = name
        }
        else if let vc = segue.destination as? SeeReviewsController {
            vc.reviews = self.textReviews
        }
        else if let vc = segue.destination as? AuthViewController {
            vc.segueToLeaveReview = true
        }
    }
    
    
    // MARK: Alert
    func alertNotSignedIn() {
        let defaultAction = UIAlertAction(title:
            "Dismiss", style: .default) { (action) in
        }
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { (action) in
            self.performSegue(withIdentifier: "loginFromInfo", sender: nil)
        }
        
        let alert = UIAlertController(title: "Not Signed In",
              message: "You must be signed in to leave a review",
              preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(signInAction)
        
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        db = Firestore.firestore()
        
        // MARK: display text
        
        
        // button background color
        btnWriteReview.backgroundColor = .systemBlue
        btnWriteReview.layer.cornerRadius = 5
//        btnWriteReview.contentEdgeInsets = UIEdgeInsets(top: -10,left: -10,bottom: -10,right: -10)
        
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
        // update ratings info
        displayRatings()
        
        // MARK: add borders
        
    }
    
    // MARK: Read from Firebase
    func displayRatings() {
        db.collection("businesses").document(placeID!).collection("reviews").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var avgRatingOverall: Float = 0.0
                var avgRating1: Float = 0.0
                var avgRating2: Float = 0.0
                var avgRating3: Float = 0.0
                var avgRating4: Float = 0.0
                var numRatings: Int = 0
                for document in querySnapshot!.documents {
//                  print("\(document.documentID) => \(document.data())")
                    numRatings += 1
                    avgRating1 += document.get("rating1") as! Float
                    avgRating2 += document.get("rating2") as! Float
                    avgRating3 += document.get("rating3") as! Float
                    avgRating4 += document.get("rating4") as! Float
                    avgRatingOverall += avgRating1 + avgRating2 + avgRating3 + avgRating4
                    avgRatingOverall /= 4
                    let textReview: String = document.get("textReview") as! String
                    self.textReviews.append(textReview)
                }
                avgRating1 /= Float(numRatings)
                avgRating2 /= Float(numRatings)
                avgRating3 /= Float(numRatings)
                avgRating4 /= Float(numRatings)
                avgRatingOverall /= Float(numRatings)
                
                // set the views
                self.starsOverall.rating = avgRatingOverall
                self.starsCat1.rating = avgRating1
                self.starsCat2.rating = avgRating2
                self.starsCat3.rating = avgRating3
                self.starsCat4.rating = avgRating4
                self.displayedStars.rating = avgRatingOverall
                self.displayedRatingNum.text = String(format: "%.1f", avgRatingOverall)
                self.displayedNumReviews.text = "(" + String(numRatings) + ")"
                
                // MARK: display 3 reviews
                var counter = 0
                while counter < 3 && counter < self.textReviews.count {
                    if counter == 0 {
                        self.review0.reviewText.text = self.textReviews[0]
                    } else if counter == 1 {
                        self.review1.reviewText.text = self.textReviews[1]
                    } else if counter == 2 {
                        self.review2.reviewText.text = self.textReviews[2]
                    }
                    counter += 1
                }

            }
            
        }
        
    }
    
}

