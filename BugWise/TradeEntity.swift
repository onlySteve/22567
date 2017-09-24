//
//  TradeEntity.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class TradeEntity: Object, Mappable {
    
    dynamic var id = 0
    dynamic var title: String?
    dynamic var strength: String?
    dynamic var form: String?
    dynamic var schedule: String?
    dynamic var manuf: String?
    dynamic var priority = 0
    var price = List<PriceEntity>()
    
    // MARK: JSON
    required convenience init?(map: Map) {
        if map.JSON["Name"] == nil || map.JSON["Strength"] == nil || map.JSON["Form"] == nil || map.JSON["Manuf"] == nil || map.JSON["Price"] == nil {
            return nil
        }
        
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["Name"]
        strength <- map["Strength"]
        form <- map["Form"]
        schedule <- map["Schedule"]
        manuf <- map["Manuf"]
        priority <- map["priority"]
        
        var priceArray: [Dictionary<String, Any>]?
        priceArray <- map["Price"]
        
        if let priceArray = priceArray {
            for value in priceArray {
                if let priceModel = Mapper<PriceEntity>().map(JSON: value) {
                    price.append(priceModel)
                }
            }
        }
        
        
        id = ("\(String(describing: title)) + \(String(describing: strength)) + \(String(describing: form)) + \(String(describing: schedule)) + \(String(describing: manuf))").hash
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

final class PriceEntity: Object, Mappable {
    
    dynamic var id = 0
    dynamic var packageSize: String?
    dynamic var price: String?
    
    // MARK: JSON
    required convenience init?(map: Map) {
        if map.JSON["Price"] == nil || map.JSON["Packsize"] == nil {
            return nil
        }
        self.init()
    }
    
    func mapping(map: Map) {
        packageSize <- map["Packsize"]
        price <- map["Price"]
        
        id = ("\(String(describing: packageSize)) + \(String(describing: price))").hash
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

struct TradeStruct {
    var title: String
    var size: String
    var price: String
    var manuf: String
    var strength: String
    var form: String
}
