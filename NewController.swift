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
    
    // MARK: Constants
    let NUM_REVIEWS_TO_DISPLAY_DEFAULT = 3
    let NUM_REVIEWS_TO_LOAD = 10
    
    // MARK: Properties
    
    @IBOutlet weak var POIName: UILabel!
    @IBOutlet weak var POIImage: UIImageView!
    @IBOutlet weak var POIAddress: UILabel!
    @IBOutlet weak var BusinessStatus: UILabel!
    @IBOutlet weak var displayedRatingNum: UILabel!
    @IBOutlet weak var displayedStars: StarRatingView!
    @IBOutlet weak var displayedNumReviews: UILabel!
    @IBOutlet weak var starsOverall: StarRatingView!
    @IBOutlet weak var starsEmployeePPW: StarRatingView!
    @IBOutlet weak var starsPatronPPW: StarRatingView!
    @IBOutlet weak var starsDistancing: StarRatingView!
    @IBOutlet weak var starsSanitization: StarRatingView!
    @IBOutlet weak var starsConvenience: StarRatingView!
    @IBOutlet weak var btnWriteReview: UIButton!
    @IBOutlet weak var btnLoadMoreReviews: UIButton!
    @IBOutlet weak var reviewStack: UIStackView!
    @IBOutlet weak var googleAttribution: UIImageView!
    @IBOutlet weak var photoAttribution: UITextView!
    @IBOutlet weak var listingAttribution: UITextView!
    
    
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
    var numReviewsLoaded: Int = 0
    
    
    // MARK: Actions
    @IBAction func btnWriteReview(_ sender: Any) {
        if user != nil {
            // segue to ReviewController
            performSegue(withIdentifier: "showReviewController", sender: nil)
        } else {
            alertNotSignedIn()
        }
    }
    
    @IBAction func btnLoadMoreReviews(_ sender: Any) {
        // do nothing if there are not more than 3 reviews
        guard textReviews.count > NUM_REVIEWS_TO_DISPLAY_DEFAULT else {
            return
        }
        
        var counter = 0
        while counter < NUM_REVIEWS_TO_LOAD && numReviewsLoaded < textReviews.count {
            
            // load a review
            let r = Review()
            r.reviewText.text = self.textReviews[self.numReviewsLoaded]
            self.reviewStack.addArrangedSubview(r)
            
            // constraints
            r.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = r.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            NSLayoutConstraint.activate([horizontalConstraint])
            
            counter += 1
            self.numReviewsLoaded += 1
        }
        
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
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        db = Firestore.firestore()
        
        
        // button background color
        btnWriteReview.backgroundColor = .systemBlue
        btnWriteReview.layer.cornerRadius = 5
        
        // button background color
        btnLoadMoreReviews.backgroundColor = .systemBlue
        btnLoadMoreReviews.layer.cornerRadius = 5
        
        // google attr.
        googleAttribution.image = UIImage(named: "googleAttributionOnWhite")
        
        photoAttribution.textContainer.widthTracksTextView = true
        photoAttribution.isScrollEnabled = false
        
        if place.attributions != nil {
            listingAttribution.attributedText = place.attributions
        } else {
            listingAttribution.isHidden = true
        }
        
        // Update UI with POI info
        POIName.text = place.name
        POIName.font = UIFont.boldSystemFont(ofSize: 17.0)
        POIAddress.text = place.formattedAddress
        
        let thickness: CGFloat = 0.5
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.POIAddress.frame.size.height - thickness, width: self.POIAddress.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.systemGray.cgColor
        POIAddress.layer.addSublayer(bottomBorder)
        
        let bottomBusiness = CALayer()
        bottomBusiness.frame = CGRect(x:0, y: self.BusinessStatus.frame.size.height - thickness, width: self.BusinessStatus.frame.size.width, height:thickness)
        BusinessStatus.layer.addSublayer(bottomBusiness)
        
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
            self.photoAttribution?.attributedText = photoMetadata.attributions;
            if (self.photoAttribution?.attributedText.length)! > 0 {
                self.photoAttribution.isHidden = false
            }
            
//            self.photoAttribution?.attributedText = NSAttributedString(string: "test")
          }
        })
        
        
        // MARK: get reviews
        
        // get reviews from firebase by passing in placeID
        // returns a list of reviews
        // for up to 3 reviews, create a ReviewView, populate the data, and display it
//        let review0 = Review()
//        let review1 = Review()
//        let review2 = Review()
//        review0.reviewText.text = "good"
//        review1.reviewText.text = "bad"
//        review2.reviewText.text = "okay"
        
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
                var avgRatingEmployeePPW: Float = 0.0
                var avgRatingPatronPPW: Float = 0.0
                var avgRatingDistancing: Float = 0.0
                var avgRatingSanitization: Float = 0.0
                var avgRatingConvenience: Float = 0.0
                var numRatings: Int = 0
                for document in querySnapshot!.documents {
//                  print("\(document.documentID) => \(document.data())")
                    numRatings += 1
                    avgRatingOverall += document.get("ratingOverall") as! Float
                    avgRatingEmployeePPW += document.get("ratingEmployeePPW") as! Float
                    avgRatingPatronPPW += document.get("ratingPatronPPW") as! Float
                    avgRatingDistancing += document.get("ratingDistancing") as! Float
                    avgRatingSanitization += document.get("ratingSanitization") as! Float
                    avgRatingConvenience += document.get("ratingConvenience") as! Float
                    let textReview: String = document.get("textReview") as! String
                    self.textReviews.append(textReview)
                }
                avgRatingOverall /= Float(numRatings)
                avgRatingEmployeePPW /= Float(numRatings)
                avgRatingPatronPPW /= Float(numRatings)
                avgRatingDistancing /= Float(numRatings)
                avgRatingSanitization /= Float(numRatings)
                avgRatingConvenience /= Float(numRatings)
                
                // set the views
                self.starsOverall.rating = avgRatingOverall
                self.starsEmployeePPW.rating = avgRatingEmployeePPW
                self.starsPatronPPW.rating = avgRatingPatronPPW
                self.starsDistancing.rating = avgRatingDistancing
                self.starsSanitization.rating = avgRatingSanitization
                self.starsConvenience.rating = avgRatingConvenience
                self.displayedStars.rating = avgRatingOverall
                self.displayedRatingNum.text = String(format: "%.1f", avgRatingOverall)
                self.displayedNumReviews.text = "(" + String(numRatings) + ")"
                
                // MARK: display initial reviews
                while self.numReviewsLoaded < self.NUM_REVIEWS_TO_DISPLAY_DEFAULT && self.numReviewsLoaded < self.textReviews.count {
                    let r = Review()
                    r.reviewText.text = self.textReviews[self.numReviewsLoaded]
                    self.reviewStack.addArrangedSubview(r)
                    
                    // constraints
                    r.translatesAutoresizingMaskIntoConstraints = false
                    let horizontalConstraint = r.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                    NSLayoutConstraint.activate([horizontalConstraint])

                    self.numReviewsLoaded += 1
                }

            }
            
        }
        
    }
    
}

