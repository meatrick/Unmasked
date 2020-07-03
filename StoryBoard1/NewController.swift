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
    
    var placeID: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Update UI with POI info
        POIName.text = name
    }
    
//    @IBAction func unwind(_ segue: UIStoryboardSegue) { }

}
