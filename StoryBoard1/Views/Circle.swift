//
//  Circle.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/14/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit

class Circle: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var circleView: UIView!
    
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
        Bundle.main.loadNibNamed("Circle", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        circleView.layer.cornerRadius = frame.width / 2
        circleView.layer.masksToBounds = true
        circleView.backgroundColor = .gray
    }
}
