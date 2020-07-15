//
//  AuthViewController.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/12/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage



class AuthViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    
    var attemptAutoSignIn: Bool = true
    var segueToLeaveReview: Bool = false
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()
        // Automatically sign in the user.
        
        if attemptAutoSignIn {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            print(user ?? "user error")
            if let user = user {
                let uid = user.uid
                print("User id: \(uid)")
                
                if self.segueToLeaveReview {
//                    self.present(ReviewController(), animated: true)
                } else {
                    // move to next vc
                    self.performSegue(withIdentifier: "showMapView", sender: nil)
                }
                
                
            } else {
                print("No user")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    

}
