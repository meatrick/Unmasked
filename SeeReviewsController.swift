//
//  SeeReviewsController.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/14/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit

class SeeReviewsController: UIViewController {

    var reviews: [String?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addReviews()
    }

    func addReviews() {
        for review in reviews! {
            let r = Review()
            r.reviewText.text = review
            view.addSubview(r)
        }
    }
}
