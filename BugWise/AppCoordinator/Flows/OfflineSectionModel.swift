//
//  SectionModel.swift
//  BugWise
//
//  Created by olbu on 6/18/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

enum SectionType {
    case detailedText
    case header
    case surveilanceData
    case associated
}

struct OfflineSectionModel {
    var items: Array<BaseReturnModel>
    var selected: Bool
}

