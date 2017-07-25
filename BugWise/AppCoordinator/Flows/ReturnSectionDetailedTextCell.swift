//
//  ReturnSectionDetailedText.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

class ReturnSectionDetailedTextCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public func config(with model: ReturnDetailedTextModel) {
        
        titleLabel.attributedText = model.title.stringFromHtml()
    }
}
