//
//  StarterView.swift
//  BugWise
//
//  Created by olbu on 6/2/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

// MARK:- Protocol

enum StartFlow : String {
    case patient
    case healthCareProvider
}

typealias StartFlowSelect = (_ flow: StartFlow) -> ()

protocol StartView: BaseView {
    var onFlowSelect: (StartFlowSelect)? { get set }
}
