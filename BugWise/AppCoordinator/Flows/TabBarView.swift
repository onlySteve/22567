//
//  TabBarView.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

// MARK:- Protocol

protocol TabBarView: class {
    var onComplete: (()->())? { get set }
    var onBack: (()->())? { get set }
    
    var onHomeFlowSelect: ((UINavigationController) -> ())? { get set }
    var onAboutFlowSelect: ((UINavigationController) -> ())? { get set }
    var onFavouritesFlowSelect: ((UINavigationController) -> ())? { get set }
    var onProfileFlowSelect: ((UINavigationController) -> ())? { get set }
    var onViewDidLoad: ((UINavigationController) -> ())? { get set }
}
