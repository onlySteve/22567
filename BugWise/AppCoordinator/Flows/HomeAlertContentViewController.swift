//
//  PageContentController.swift
//  BugWise
//
//  Created by olbu on 6/10/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RxGesture
import RxSwift

class HomeAlertContentViewController: UIViewController {
    
    typealias selectionBlock = (() -> ())?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    
    var pageIndex: Int = 0
    
    private var alertSelection: selectionBlock = nil
    private let disposeBag = DisposeBag()
    private var alert = AlertEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imagePath = alert.imagePath {
            imageView
                .kf
                .setImage(with: URL(string: imagePath),
                placeholder: UIImage(named: "bg_main"), progressBlock: nil, completionHandler: nil)
        }
        
        titleLabel.attributedText = alert.title?.stringFromHtml(textColor: .white, font: BoldFontWithSize(size: 19))
        subTitle.attributedText = alert.subTitle?.stringFromHtml(textColor: .white, font: RegularFontWithSize(size: 17))
        
        view.rx.tapGesture().when(.recognized).subscribe{ [weak self] _  in
            self?.alertSelection?()
        }.addDisposableTo(disposeBag)
        
    }
    
    static func controller(with alert: AlertEntity, index: Int, selectionAction: selectionBlock) -> HomeAlertContentViewController {
        let controller = HomeAlertContentViewController.controllerFromStoryboard(.home)
        
        controller.alert = alert
        controller.pageIndex = index
        controller.alertSelection = selectionAction
        
        return controller
    }
}
