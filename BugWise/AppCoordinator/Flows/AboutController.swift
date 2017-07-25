//
//  AboutController.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

// MARK:- Implementation

final class AboutViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AboutViewController {
    static func controller() -> AboutViewController {
        let controller = AboutViewController.controllerFromStoryboard(.tabBar)
        return controller
    }
}
