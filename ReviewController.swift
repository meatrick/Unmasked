//
//  ReviewController.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/9/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ReviewController: UIViewController, UITextViewDelegate {
    
    // MARK: Properties

    @IBOutlet weak var textReview: UITextView!
    @IBOutlet weak var btnSubmitReview: UIButton!
    @IBOutlet weak var starsOverall: RatingControl!
    @IBOutlet weak var starsEmployeePPW: RatingControl!
    @IBOutlet weak var starsPatronPPW: RatingControl!
    @IBOutlet weak var starsDistancing: RatingControl!
    @IBOutlet weak var starsSanitization: RatingControl!
    @IBOutlet weak var starsConvenience: RatingControl!
    var placeID: String?
    var placeName: String?
    var user: User?
    
    var db: Firestore!
    
    var handle: AuthStateDidChangeListenerHandle?

    
    // MARK: Actions
    
    @IBAction func submitReview(_ sender: Any) {
        print(textReview.text!)
        
        // TODO: create popup
        guard starsOverall.rating > 0 else {
            alertUnfilledForm()
            return
        }

        guard starsEmployeePPW.rating > 0 else {
            alertUnfilledForm()
            return
        }

        guard starsPatronPPW.rating > 0 else {
            alertUnfilledForm()
            return
        }

        guard starsDistancing.rating > 0 else {
            alertUnfilledForm()
            return
        }
        
        guard starsSanitization.rating > 0 else {
            alertUnfilledForm()
            return
        }
        
        guard starsConvenience.rating > 0 else {
            alertUnfilledForm()
            return
        }
        
        // MARK: Firestore
        // get ref to place
        let placeRef = db.collection("businesses").document(placeID!)
        
        // ensure that the place's name is stored in the db
        placeRef.updateData([
            "name": placeName!])
        
        // add the review to the db
        var reviewRef: DocumentReference? = nil
        reviewRef = placeRef.collection("reviews").addDocument(data: [
            "textReview": textReview.text!,
            "ratingOverall": starsOverall.rating,
            "ratingEmployeePPW": starsEmployeePPW.rating,
            "ratingPatronPPW": starsPatronPPW.rating,
            "ratingDistancing": starsDistancing.rating,
            "ratingSanitization": starsSanitization.rating,
            "ratingConvenience": starsConvenience.rating,
            "UserID": user!.uid,]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(reviewRef!.documentID)")
                }
            }
        
        // create a popup that says the review has been submitted
        alertReviewSubmitted()
        
    }
    
    // MARK: Alerts
    func alertUnfilledForm() {
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { (action) in
        }

        // Create and configure the alert controller.
        let alert = UIAlertController(title: "Unfilled Ratings",
              message: "Please leave a rating for all categories",
              preferredStyle: .alert)
        alert.addAction(defaultAction)

        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    func alertReviewSubmitted() {
        let defaultAction = UIAlertAction(title:
            "Ok", style: .default) { (action) in
        }
        
        let alert = UIAlertController(title: "Review Submitted",
              message: "Debug, not actually submitted yet",
              preferredStyle: .alert)
        alert.addAction(defaultAction)
        
        
        self.present(alert, animated: true) {
            // The alert was presented
        }
    }
    
    
    // MARK: viewLoading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button pretty
        btnSubmitReview.backgroundColor = .systemBlue
        btnSubmitReview.layer.cornerRadius = 5
        
        textReview.layer.borderWidth = 2
        textReview.layer.borderColor = UIColor.systemGray.cgColor
        textReview.layer.cornerRadius = 5
        textReview.layer.masksToBounds = true
        
        // placeholder text
        textReview.textColor = .lightGray
        textReview.text = "(Optional) Leave a review..."
        
        // Done button
        self.textReview.delegate = self
        self.addDoneButtonOnKeyboard()
        
        // notifications for keyboard to adjust view
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Firestore
        db = Firestore.firestore()
        
    }
    
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
    
    // MARK: placeholder text
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if textReview.textColor == UIColor.lightGray && textReview.isFirstResponder {
            textReview.text = nil
            if self.traitCollection.userInterfaceStyle == .dark {
                textReview.textColor = .white
            } else {
                textReview.textColor = .black
            }
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if textReview.text.isEmpty || textReview.text == "" {
            textReview.textColor = .lightGray
            textReview.text = "(Optional) Leave a review..."
        }
    }
    
    
    // MARK: adjust view for keys
    @objc func adjustForKeyboard(notification: Notification)
    {
        if notification.name == UIResponder.keyboardWillHideNotification {
            // move back the root view origin to zero
            self.view.frame.origin.y = 0
        } else {
              guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                // if keyboard size is not available for some reason, dont do anything
                return
             }
            if (self.textReview.frame.origin.y > keyboardSize.height) {
                // move the root view up by the distance of keyboard height
                self.view.frame.origin.y = 0 - keyboardSize.height
            }
        }
        textReview.scrollIndicatorInsets = textReview.contentInset
    }


    // ends text editing on "return"
//    func textView(_ textReview: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//          if(text == "\n") {
//              textReview.resignFirstResponder()
//                print("Text field enter received")
//              return false
//          }
//          return true
//      }
    
    // MARK: Done button for keys
    func addDoneButtonOnKeyboard() {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(ReviewController.doneButtonAction))

            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)

            doneToolbar.items = items
            doneToolbar.sizeToFit()

            self.textReview.inputAccessoryView = doneToolbar
        }

    @objc func doneButtonAction() {
            self.textReview.resignFirstResponder()
            /* Or:
            self.view.endEditing(true);
            */
        }
}


