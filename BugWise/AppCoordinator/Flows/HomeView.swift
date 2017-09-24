//
//  HomeView.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

typealias MenuItemSelectAction = (_ menuItem: MenuType) -> ()

// MARK:- Protocol

protocol HomeView: BaseView {
    var onComplete: (()->())? { get set }
    var onMenuItemSelect: (MenuItemSelectAction)? { get set }
    var onSearchItemSelect: ((SearchModuleItem) -> ())? { get set }
    var onMedicineReminderSelect: (() -> ())? { get set }
}
