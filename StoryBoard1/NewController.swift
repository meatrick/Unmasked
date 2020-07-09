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
    
    
    @IBAction func btnWriteReview(_ sender: Any) {
        // segue to ReviewController
        performSegue(withIdentifier: "showReviewController", sender: nil)
    }
    
    
    var placeID: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    var placesClient: GMSPlacesClient?
    var place: GMSPlace!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(NewController.updateTextView(notification:)), name: Notification.Name.UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(NewController.updateTextView(notification:)), name: Notification.Name.UIResponder.keyboardWillHideNotification, object: nil)
        
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

//    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.backgroundColor = UIColor.lightGray
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        textView.backgroundColor = UIColor.white
//    }
    
    /* Updated for Swift 4 */
    func textView(_ TextViewReview: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          if(text == "\n") {
              TextViewReview.resignFirstResponder()
              return false
          }
          return true
      }
}

