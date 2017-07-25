//
//  HomeMenuType.swift
//  BugWise
//
//  Created by olbu on 6/27/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

enum MenuType {
    case antibiotics
    case microbes
    case infections
    case interactions
    case duplications
    case doseCalculators
    case generalAlerts
    case surveillanceData
    
    static let allItems = [antibiotics, microbes, infections, interactions, duplications, doseCalculators, generalAlerts, surveillanceData]
}

extension MenuType {
    
    var title: String {
        switch self {
        case.antibiotics : return "Antibiotics"
        case.microbes : return "Microbes"
        case.infections : return "Infections"
        case.interactions : return "Interactions"
        case.duplications : return "Duplications"
        case.doseCalculators : return "Calculators"
        case.generalAlerts : return "General Alerts"
        case.surveillanceData : return "Surveillance Data"
        }
    }
    
    var image: UIImage {
        switch self {
        case.antibiotics : return #imageLiteral(resourceName: "antibiotic_w")
        case.microbes : return #imageLiteral(resourceName: "microbe_w")
        case.infections : return #imageLiteral(resourceName: "infection")
        case.interactions : return #imageLiteral(resourceName: "interact_w")
        case.duplications : return #imageLiteral(resourceName: "duplicate_w")
        case.doseCalculators : return #imageLiteral(resourceName: "dose_w")
        case.generalAlerts : return #imageLiteral(resourceName: "alert_w")
        case.surveillanceData : return #imageLiteral(resourceName: "data_w")
        }
    }
}
