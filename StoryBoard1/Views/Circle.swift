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
        
//        contentView.layer.cornerRadius = frame.width / 2
//        contentView.layer.masksToBounds = true
//        contentView.backgroundColor = .gray
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if (frame.width != frame.height) {
//            NSLog("Ended up with a non-square frame -- so it may not be a circle");
//        }
//        layer.cornerRadius = frame.width / 2
//        layer.masksToBounds = true
//    }
    
//    override func drawRect(_ rect: CGRect) {
//        self.layer.cornerRadius = self.bounds.size.width/2
//    }
}
