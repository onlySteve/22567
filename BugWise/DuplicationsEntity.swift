//
//  DuplicationSearchEntity.swift
//  BugWise
//
//  Created by olbu on 7/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import ObjectMapper

struct DuplicationsEntity: Mappable {
    var items = Array<DuplicationsDetailEntity>()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        var itemsDict: Array<Dictionary<String, Any>>?
        itemsDict <- map["DATA"]
        
        if let itemsDict = itemsDict {
            for value in itemsDict {
                items.append(Mapper<DuplicationsDetailEntity>().map(JSON: value)!)
            }
        }
    }
}

struct DuplicationsDetailEntity: Mappable {
    var desc: String?
    var type: String?
    var medicines: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        desc <- map["Description"]
        type <- map["Type"]
        medicines <- map["Medicines"]
    }
}
