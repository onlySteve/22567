//
//  SearchEntity.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import ObjectMapper

struct SearchEntity: Mappable {
    var id: String?
    var title: String?
    var firstLetter: String = ""
    
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        id <- map["ID"]
        title <- map["FullName"]
        firstLetter <- (map["FullName"], TransformOf<String, String>(fromJSON: { $0![0] }, toJSON: { $0 }))
    }
}

enum SearchType: String {
    case antimicrobial = "antimicrobial"
    case medicine = "medicine"
}

struct SearchOnlineRequestEntity {
    var text: String?
    var type: SearchType
}
