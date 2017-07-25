//
//  DuplicationsResultTableViewCell.swift
//  BugWise
//
//  Created by olbu on 7/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

final class DuplicationsResultTableViewCell: BaseCell {
    
    @IBOutlet weak var medicinesLabel: InteractionsSectionLabel!
    @IBOutlet weak var typeLabel: InteractionsSectionLabel!
    @IBOutlet weak var descLabel: InteractionsSectionLabel!
    
    public func config(with entity: DuplicationsDetailEntity) {
        descLabel.desc = entity.desc
        typeLabel.desc = entity.type
        medicinesLabel.desc = entity.medicines
    }
}

