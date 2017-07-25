//
//  InteractionsSectionLabel.swift
//  BugWise
//
//  Created by olbu on 7/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

@IBDesignable

class InteractionsSectionLabel: CommonCustomUIBase {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var desc: String? {
        didSet {
            descriptionLabel.text = desc
        }
    }
    
    override func setup() {
        titleLabel.textColor = CommonAppearance.boldGreyColor
        titleLabel.font = RegularFontWithSize()
        
        descriptionLabel.font = RegularFontWithSize(size: 14)
    }
    
}

