//
//  CalculatorResultView.swift
//  BugWise
//
//  Created by olbu on 6/27/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

@IBDesignable

class CalculatorResultHeader: CommonCustomUIBase {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func setup() {
        titleLabel.textColor = UIColor.white
        titleLabel.font = RegularFontWithSize(size: 16)
        titleLabel.backgroundColor = CommonAppearance.yellowToOrangeColor
    }
}
