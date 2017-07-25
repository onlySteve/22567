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
    
//    var severity = ModuleSearchType.condition.rawValue
//    
//    var typeEnum: ModuleSearchType {
//        get{
//            return ModuleSearchType(rawValue: type)!
//        }
//        set{
//            type = newValue.rawValue
//        }
//    }
    
    var details = Array<InteractionsDetailEntity>()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        firstMedcine <- map["DATA.0.MedicineA"]
        secondMedcine <- map["DATA.0.MedicineB"]
        severityType <- map["DATA.0.severity"]
        
        var detailsDict: Dictionary<String, Dictionary<String, Any>>?
        detailsDict <- map["DATA.0.Details"]
        
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
