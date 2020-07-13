//
//  FirebaseRegister.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/12/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
      Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
          if let e = error{
              callback?(e)
              return
          }
          callback?(nil)
      }
}