//
//  FirebaseLogin.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/12/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

func login(withEmail email: String, password: String, _ callback: ((Error?) -> ())? = nil){
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        if let e = error{
            callback?(e)
            return
        }
        callback?(nil)
    }
}
