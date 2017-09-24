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
    case availableAs
    case storageInstructions
    case uses
    case inadvisibleUses
    case sideEffects
}

extension RetrunSectionHeaderTypeEnum {
    var title: String {
        switch self {
        case .description: return BusinessModel.shared.applicationState == .patient ? "What is it?" : "Description"
        case .diagnosis: return "Diagnosis"
        case .associatedMicrobes: return BusinessModel.shared.applicationState == .patient ? "Linked Bugs" : "Associated Microbes"
        case .references: return "References"
        case .classType: return "Class"
        case .strength: return "Strength"
        case .dose: return "Dose"
        case .indication: return "Indication"
        case .methodOfAdministration: return "Administration"
        case .associatedInfections: return BusinessModel.shared.applicationState == .patient ? "Linked Infections" : "Associated Infections"
        case .treatment: return "Treatment"
        case .availableAs: return "Available as"
        case .storageInstructions: return "Storage instructions"
        case .uses: return "Uses"
        case .inadvisibleUses: return "Inadvisable Uses"
        case .sideEffects: return "Possible Side Effects"
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
        case .availableAs: return #imageLiteral(resourceName: "description_y")
        case .storageInstructions: return #imageLiteral(resourceName: "method_y")
        case .uses: return #imageLiteral(resourceName: "indication_y")
        case .inadvisibleUses: return #imageLiteral(resourceName: "description_y")
        case .sideEffects: return #imageLiteral(resourceName: "description_y")
        }
    }
}

enum ReturnSectionHeaderImage: String {
    case oral = "oral"
    case iv = "iv"
    case dual = "dual"
    
    var image: UIImage {
        switch self {
        case .oral: return #imageLiteral(resourceName: "oral")
        case .iv: return #imageLiteral(resourceName: "iv")
        case .dual: return #imageLiteral(resourceName: "dual")
        }
    }
}

class BaseReturnModel: NSObject {
    
}

class ReturnHeaderModel: BaseReturnModel {
    let type: EntitiesType
    let titleImage: String?
    let title: String?
    let subtitle: String?
    let imagePath: String?
    let tradeAction: (voidBlock)?
    
    init(type: EntitiesType, titleImage: String? = nil, title: String?, subtitle: String? = nil, imagePath: String? = nil, tradeAction: (voidBlock)? = nil) {
        self.titleImage = titleImage
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

