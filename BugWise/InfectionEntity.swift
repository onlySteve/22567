//
//  InfectionEntity.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class InfectionEntity: BaseEntity {
    
    dynamic var title: String?
    dynamic var desc: String?
    dynamic var imagePath: String?
    dynamic var diagnosis: String?
    dynamic var firstLine: String?
    dynamic var secondLine: String?
    var associatedMicrobes = List<AssociatedEntity>()
    dynamic var references: String?
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    override func mapping(map: Map) {
        id <- map["ID"]
        title <- map["Detail.Name"]
        desc <- map["Detail.Description"]
        imagePath <- map["Detail.Image"]
        diagnosis <- map["Detail.Diagnosis"]
        firstLine <- map["Detail.1stLine"]
        secondLine <- map["Detail.2ndLine"]
        
        references <- map["Detail.References"]
        
        var associatedDict: Dictionary<String, String>?
        associatedDict <- map["Detail.AssociatedMicrobes"]
        
        if let associatedDict = associatedDict {
            for (key, value) in associatedDict {
                if let associatedEntity = Mapper<AssociatedEntity>().map(JSON: ["id": key, "title": value]) {
                    associatedMicrobes.append(associatedEntity)
                }
            }
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

final class AssociatedEntity: Object, Mappable {
    
    dynamic var id: String = "0"
    dynamic var title: String?
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        title <- map["title"]
    }
    
    override class func primaryKey() -> String? {
        return "title"
    }
}

