//
//  SurveillanceEntity.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import ObjectMapper

struct SurveillanceEntity: Mappable {
    var microbe: String?
    var cases: String?
    var susceptibility: String?
    var specialNote: String?
    var note: String?
    var source: String?
    var sampleType: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        microbe <- map["Microbe"]
        cases <- map["Cases"]
        susceptibility <- map["Susceptibility"]
        specialNote <- map["SpecialNote"]
        note <- map["Note"]
        source <- map["Source"]
        sampleType <- map["SampleType"]
    }
}

struct SurveillanceRequestEntity {
    var microbe: SearchModuleItem?
    var antibiotic: SearchModuleItem?
    var sector: String
    var location: String
}
