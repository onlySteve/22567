//
//  SurveillanceTableViewHeader.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

@IBDesignable

class SurveillanceTableViewHeader: CommonCustomUIBase {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var antimicrobialsLabel: UILabel!
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var susceptibilityLabel: UILabel!
    
    override func setup() {
        titleLabel.font = BoldFontWithSize(size: 17)
        antimicrobialsLabel.font = RegularFontWithSize(size: 16)
        antimicrobialsLabel.textColor = CommonAppearance.blueColor
        
        casesLabel.font = RegularFontWithSize(size: 16)
        casesLabel.textColor = CommonAppearance.blueColor
        
        susceptibilityLabel.font = RegularFontWithSize(size: 16)
        susceptibilityLabel.textColor = CommonAppearance.blueColor
    }
    
}

