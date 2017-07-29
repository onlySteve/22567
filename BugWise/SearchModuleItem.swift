//
//  SearchTerm.swift
//  BugWise
//
//  Created by olbu on 6/12/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

enum EntitiesType: String {
    case infections = "Conditions"
    case microbes = "Microbes"
    case antibiotics = "Drugs"
}

enum ModuleType: String {
    case conditions = "Conditions"
    case microbes = "Microbes"
    case drugs = "Drugs"
}

enum ModuleSearchType: String {
    case condition = "Condition"
    case microbe = "Microbe"
    case drug = "Drug"
}

extension ModuleSearchType {
    var title: String {
        switch self {
        case .condition: return "Infection"
        case .microbe: return "Microbe"
        case .drug: return "Antibiotic"
        }
    }
}

final class SearchModuleItem: Object, Mappable {
    dynamic var type = ModuleSearchType.condition.rawValue
    
    var typeEnum: ModuleSearchType {
        get{
            return ModuleSearchType(rawValue: type)!
        }
        set{
            type = newValue.rawValue
        }
    }
    
    dynamic var firstLetter = ""
    dynamic var isFavorite: Bool = false
    dynamic var id: String = "0"
    dynamic var title: String?
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    func mapping(map: Map) {
        title <- map["Name"]
        id <- map["ID"]
        
        firstLetter <- (map["Name"], TransformOf<String, String>(fromJSON: { $0![0] }, toJSON: { $0 }))
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
