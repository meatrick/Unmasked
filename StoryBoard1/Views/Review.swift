//
//  Review.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/9/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit

class Review: UIView {
    // MARK: Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var reviewText: UITextView!
    
//    var rating: Int
        
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Review", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 334, height: 250)
        // if using in, say, a vertical stack view, the width is ignored
    }

    override func prepareForInterfaceBuilder() {
         invalidateIntrinsicContentSize()
    }
}
