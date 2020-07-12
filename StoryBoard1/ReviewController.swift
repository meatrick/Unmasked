//
//  ReviewController.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/9/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit

class ReviewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textReview: UITextView!
    
    @IBAction func submitReview(_ sender: Any) {
        print(textReview.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    // MARK: placeholder
    
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


