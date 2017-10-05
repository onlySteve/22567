//
//  AboutController.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import ImageScrollView

// MARK:- Implementation

final class AboutViewController: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let image = UIImage(named: "aboutContent.jpg")  else {
            return
        }
        imageScrollView.display(image: image)
    }
    
}

extension AboutViewController {
    static func controller() -> AboutViewController {
        let controller = AboutViewController.controllerFromStoryboard(.tabBar)
        return controller
    }
}
