//
//  ReturnSectionHeaderCell.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

class ReturnSectionHeaderCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    public func config(with model: ReturnSectionHeaderModel, selected: Bool) {
        
        typeImageView.image = model.type.image
        statusImageView.image = selected ? #imageLiteral(resourceName: "arrow_up_g") : #imageLiteral(resourceName: "arrow_down_g")
        
        titleLabel.text = model.type.title
    }
}
