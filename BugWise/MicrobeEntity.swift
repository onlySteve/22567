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
        
        
        var associatedArray: Array<Dictionary<String, Any>>?
        associatedArray <- map["Detail.AssociatedInf"]
        
        if let associatedArray = associatedArray {
            for dict in associatedArray {
                if let associatedEntity = Mapper<AssociatedEntity>().map(JSON: dict) {
                    associatedEntity.primaryKeyID = "\(id)\(associatedEntity.id)"
                    associatedInfections.append(associatedEntity)
                }
            }
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
