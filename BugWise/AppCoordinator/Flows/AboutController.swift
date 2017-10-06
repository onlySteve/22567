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
        
        let resize = resizeImage(image: image, newWidth: view.frame.width, newHeight: view.frame.height)
        imageScrollView.display(image: resize ?? image)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newHeight)))
        imageView.contentMode = .scaleToFill
        imageView.image = image
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

extension AboutViewController {
    static func controller() -> AboutViewController {
        let controller = AboutViewController.controllerFromStoryboard(.tabBar)
        return controller
    }
}
