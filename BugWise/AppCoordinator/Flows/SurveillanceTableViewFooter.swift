//
//  SurveillanceTableViewFooter.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//

@IBDesignable

class SurveillanceTableViewFooter: CommonCustomUIBase {
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func setup() {
        
        noteLabel.font = RegularFontWithSize(size: 12)
        noteLabel.textColor = CommonAppearance.blueColor
        
        sourceLabel.font = RegularFontWithSize(size: 12)
        sourceLabel.textColor = CommonAppearance.blueColor
    }
    
}


