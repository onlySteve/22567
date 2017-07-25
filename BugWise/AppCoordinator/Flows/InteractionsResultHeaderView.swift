//
//  InteractionsResultHeaderView.swift
//  BugWise
//
//  Created by olbu on 7/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

@IBDesignable

class InteractionsResultHeaderView: CommonCustomUIBase {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func setup() {
        titleLabel.textColor = CommonAppearance.blueColor
        statusImage.image = nil
    }
    
    public func config(firstItem: String?, secondItem: String?, image: UIImage?, description: String?) {
        
        if let image = image {
            statusImage.image = image
        }
        
        titleLabel.text = String(format: "%@\nand\n%@", firstItem ?? "", secondItem ?? "")
        descLabel.text = description
    }
    
}


