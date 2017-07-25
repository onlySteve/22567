//
//  SurveillanceCell.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//


final class SurveillanceTableViewCell: BaseCell {
    
    @IBOutlet weak var drugLabel: UILabel!
    @IBOutlet weak var susceptibilityLabel: UILabel!
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var specialNoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        drugLabel.font = RegularFontWithSize(size: 15)
        specialNoteLabel.font = RegularFontWithSize(size: 15)
        specialNoteLabel.textColor = CommonAppearance.boldGreyColor
        
        susceptibilityLabel.font = RegularFontWithSize(size: 15)
        casesLabel.font = RegularFontWithSize(size: 15)
    }
    
    public func config(with survEntity: SurveillanceEntity) {
        drugLabel.text = survEntity.microbe
        casesLabel.text = survEntity.cases
        susceptibilityLabel.text = survEntity.susceptibility
        specialNoteLabel.text = survEntity.specialNote
    }
}
