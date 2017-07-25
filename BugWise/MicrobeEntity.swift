//
//  MicrobeEntity.swift
//  BugWise
//
//  Created by olbu on 6/12/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

final class MicrobeEntity: BaseEntity {
   
    dynamic var title: String?
    dynamic var desc: String?
    dynamic var imagePath: String?
    dynamic var treatment: String?
    var associatedInfections = List<AssociatedEntity>()
    dynamic var references: String?
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    override func mapping(map: Map) {
        id <- map["ID"]
        title <- map["Detail.Name"]
        imagePath <- map["Detail.Image"]
        desc <- map["Detail.Description"]
        treatment <- map["Detail.Treatment"]
        
        references <- map["Detail.References"]
        
        
        var associatedDict: Dictionary<String, String>?
        associatedDict <- map["Detail.AssociatedInfections"]
        
        if let associatedDict = associatedDict {
            
            for (index, dict) in associatedDict.enumerated() {
                if let associatedEntity = Mapper<AssociatedEntity>().map(JSON: ["primaryKey": "\(id)\(dict.key)","id": dict.key, "title": dict.value, "order": index.description]) {
                    associatedInfections.append(associatedEntity)
                }
            }
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
