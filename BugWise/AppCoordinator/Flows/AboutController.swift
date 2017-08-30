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
        
        guard let image = UIImage(named: "aboutContent.jpg")  else {
            return
        }
        
        imageScrollView.display(image: image)
    }

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}



extension AboutViewController {
    static func controller() -> AboutViewController {
        let controller = AboutViewController.controllerFromStoryboard(.tabBar)
        return controller
    }
}
