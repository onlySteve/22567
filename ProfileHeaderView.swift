//
//  RegistrationHeaderView.swift
//  BugWise
//
//  Created by olbu on 6/4/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit


@IBDesignable

class ProfileHeaderView: CommonCustomUIBase {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: SeparatorView!
    
    @IBInspectable var separatorColor: UIColor = CommonAppearance.greyColor {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }
    
    @IBInspectable var bgColor: UIColor = .clear {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    
    override func setup() {
        titleLabel.textColor = UIColor(netHex: 0x5B5B5D)
        titleLabel.font = RegularFontWithSize(size: 17)
    }
    
    func config(withText: String) {
        titleLabel.text = withText
    }
}
