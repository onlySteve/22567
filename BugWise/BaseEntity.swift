//
//  BaseEntity.swift
//  BugWise
//
//  Created by olbu on 6/18/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RealmSwift
import ObjectMapper

class BaseEntity: Object, Mappable {
    
    dynamic var id: String = "0"
    dynamic var parentID: String = ""
    dynamic var isFavorite = false
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    func mapping(map: Map) {
        
    }
}

