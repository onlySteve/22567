//
//  BaseLabel.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
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
        self.font = RegularFontWithSize()
        self.textColor = UIColor(netHex: 0x000000)
    }
}


class TitleLabel: BaseLabel {
    override func setup() {
        self.font = BoldFontWithSize(size: 16)
        self.textColor = UIColor(netHex: 0x000000)
    }
}

class DescriptionLabel: BaseLabel {
    override func setup() {
        self.font = RegularFontWithSize(size: 14)
        self.textColor = UIColor(netHex: 0x000000)
    }
}
