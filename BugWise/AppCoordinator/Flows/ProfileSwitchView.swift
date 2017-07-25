//
//  ProfileSwitchView.swift
//  BugWise
//
//  Created by olbu on 6/5/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

@IBDesignable

class ProfileSwitchView: CommonCustomUIBase {
    
    @IBOutlet weak var switchItem: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: SeparatorView!
    
    @IBInspectable var enabled: Bool = false {
        didSet {
            switchItem.isOn = enabled
        }
    }
    
    @IBInspectable var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    
    @IBInspectable var separatorColor: UIColor = CommonAppearance.greyColor {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }
    
    
    
    override func setup() {
        
    }
    
    
}

