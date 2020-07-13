//
//  UserReview.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/13/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class UserReview {
    // MARK: Properties
    var textReview: String?
    var rating1: Int8!
    var rating2: Int8!
    var rating3: Int8!
    var rating4: Int8!
    var ratingAverage: Float!
    var User: User?
    var author: String?
    var timeStamp: FirebaseFirestore.Timestamp!
}
