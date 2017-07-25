//
//  ReturnHeaderModel.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

enum RetrunSectionHeaderTypeEnum {
    case description
    case diagnosis
    case associatedMicrobes
    case references
    case classType
    case strength
    case dose
    case indication
    case methodOfAdministration
    case associatedInfections
    case treatment
}

extension RetrunSectionHeaderTypeEnum {
    var title: String {
        switch self {
        case .description: return "Description"
        case .diagnosis: return "Diagnosis"
        case .associatedMicrobes: return "Associated Microbes"
        case .references: return "References"
        case .classType: return "Class"
        case .strength: return "Strength"
        case .dose: return "Dose"
        case .indication: return "Indication"
        case .methodOfAdministration: return "Administration"
        case .associatedInfections: return "Associated Infections"
        case .treatment: return "Treatment"
        }
    }
    
    var image: UIImage {
        switch self {
        case .description: return #imageLiteral(resourceName: "description_y")
        case .diagnosis: return #imageLiteral(resourceName: "diagnos_y")
        case .associatedMicrobes: return #imageLiteral(resourceName: "reference_y")
        case .references: return #imageLiteral(resourceName: "reference")
        case .classType: return #imageLiteral(resourceName: "description_y")
        case .strength: return #imageLiteral(resourceName: "strength_y")
        case .dose: return #imageLiteral(resourceName: "dose_y")
        case .indication: return #imageLiteral(resourceName: "indication_y")
        case .methodOfAdministration: return #imageLiteral(resourceName: "method_y")
        case .associatedInfections: return #imageLiteral(resourceName: "reference_y")
        case .treatment: return #imageLiteral(resourceName: " treatment_y")
        }
    }
}

class BaseReturnModel: NSObject {
    
}

class ReturnHeaderModel: BaseReturnModel {
    let type: EntitiesType
    let title: String?
    let subtitle: String?
    let imagePath: String?
    let tradeAction: (voidBlock)?
    
    init(type: EntitiesType, title: String?, subtitle: String? = nil, imagePath: String? = nil, tradeAction: (voidBlock)? = nil) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.imagePath = imagePath
        self.tradeAction = tradeAction
    }
}

class ReturnHeaderButtonModel: BaseReturnModel {
    let action: (voidBlock)?
    
    init(action: (voidBlock)?) {
        self.action = action
    }
}

class ReturnSectionHeaderModel: BaseReturnModel {
    let type: RetrunSectionHeaderTypeEnum
    
    init(type: RetrunSectionHeaderTypeEnum) {
        self.type = type
    }
}

class ReturnDetailedTextModel: BaseReturnModel {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

class ReturnActionsModel: BaseReturnModel {
    let items: Array<AssociatedEntity>
    var alreadySetup: Bool
    
    init(items: Array<AssociatedEntity>) {
        self.items = items
        self.alreadySetup = false
    }
}

