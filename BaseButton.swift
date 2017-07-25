//
//  BaseButton.swift
//  BugWise
//
//  Created by olbu on 5/30/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit


class BaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setup() {
        self.titleLabel?.font = RegularFontWithSize()
        self.setTitleColor(UIColor(netHex: 0xFFFFFF), for: .normal)
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
}

class BaseRedButton: BaseButton {
    override func setup() {
        super.setup()
        self.setBackgroundColor(color: CommonAppearance.redColor, forState: .normal)
        self.setBackgroundColor(color: CommonAppearance.redColor.withAlphaComponent(0.7), forState: .highlighted)
    }
}

class BaseOrangeButton: BaseButton {
    override func setup() {
        super.setup()
        self.setBackgroundColor(color: CommonAppearance.orangeColor, forState: .normal)
        self.setBackgroundColor(color: CommonAppearance.orangeColor.withAlphaComponent(0.7), forState: .highlighted)
    }
}
