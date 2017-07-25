//
//  AntibioticEntity.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

final class AntibioticEntity: BaseEntity {
    
    dynamic var heading: String?
    dynamic var classType: String?
    dynamic var strength: String?
    dynamic var dose: String?
    dynamic var indication: String?
    dynamic var administration: String?
    var trades = List<TradeEntity>()

    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        heading <- map["Heading"]
        classType <- map["Class"]
        strength <- map["Strength"]
        dose <- map["Dose"]
        indication <- map["Indication"]
        administration <- map["Administration"]
        
        
        var tradesArray: [Dictionary<String, Any>]?
        tradesArray <- map["Trades"]
        
        if let tradesArray = tradesArray {
            for value in tradesArray {
                if let trade = Mapper<TradeEntity>().map(JSON: value) {
                    trades.append(trade)
                }
            }
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
