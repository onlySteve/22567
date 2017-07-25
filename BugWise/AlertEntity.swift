//
//  AlertModel.swift
//  BugWise
//
//  Created by olbu on 6/10/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

import RealmSwift
import ObjectMapper

final class AlertEntity: Object, Mappable {
    dynamic var id = 0
    dynamic var title: String?
    dynamic var imagePath: String?
    dynamic var subTitle: String?
    dynamic var content: String?
    
    // MARK: JSON
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["Heading"]
        imagePath <- map["img"]
        subTitle <- map["Teaser"]
        content <- map["content"]
        
        id = "\(title) + \(subTitle) + \(content) + \(imagePath)".hash
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
