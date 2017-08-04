//
//  InteractionsEntity.swift
//  BugWise
//
//  Created by olbu on 7/2/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import ObjectMapper


enum SeverityType: String {
    case caution = "caution.png"
    case contraindicated = "skull.png"
    case avoid = "unsafe.png"
    
    var title: String {
        switch self {
        case .avoid: return "Avoid combination"
        case .contraindicated: return "Contraindicated"
        case .caution: return "Caution advised"
        }
    }
    
    var image: UIImage {
        switch self {
        case .caution: return #imageLiteral(resourceName: "caution")
        case .contraindicated: return #imageLiteral(resourceName: "contraindicated")
        case .avoid: return #imageLiteral(resourceName: "advised")
        }
    }
    
}

struct InteractionsEntity: Mappable {
    
    var firstMedcine: String?
    var secondMedcine: String?
    var severityType: SeverityType?
        
    var details = Array<InteractionsDetailEntity>()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        firstMedcine <- map["MedicineA"]
        secondMedcine <- map["MedicineB"]
        severityType <- map["severity"]
        
        var detailsDict: Dictionary<String, Dictionary<String, Any>>?
        detailsDict <- map["Details"]
        
        if let detailsDict = detailsDict {
            for (key, value) in detailsDict {
                details.append(Mapper<InteractionsDetailEntity>().map(JSON: value)!)
            }
        }
    }
}

struct InteractionsDetailEntity: Mappable {
    var category: String?
    var desc: String?
    var refernceID: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        category <- map["Category"]
        desc <- map["Description"]
        refernceID <- map["ReferenceID"]
    }

}
