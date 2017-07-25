//
//  PinCodeView.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

// MARK:- Protocol

protocol PinCodeView: BaseView {
    var onComplete: ((String) -> ())? { get set }
}
