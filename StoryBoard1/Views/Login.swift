//
//  Login.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 7/14/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

import UIKit

class Login: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Login", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
