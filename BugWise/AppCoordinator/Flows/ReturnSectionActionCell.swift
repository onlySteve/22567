//
//  ReturnSectionActionCell.swift
//  BugWise
//
//  Created by olbu on 6/19/17.
//  Copyright © 2017 olbu. All rights reserved.
//

class ReturnSectionActionCell: UITableViewCell {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelTrailingToSuperview: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        button.titleLabel?.font = RegularFontWithSize(size: 13)
        button.isHidden = true
        
        label.font = RegularFontWithSize(size: 13)
    }
    
    func config(with model: AssociatedEntity) {
        label.text = model.title
    }
}
