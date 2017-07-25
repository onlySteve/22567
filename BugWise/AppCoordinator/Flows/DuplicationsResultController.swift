//
//  DuplicationsResultController.swift
//  BugWise
//
//  Created by olbu on 7/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift
import RxGesture
import RxDataSources

class DuplicationsResultController: BaseViewController {
    @IBOutlet weak var placeholderView: DefaultBGView!
    @IBOutlet weak var placeHolderDisclaimer: DisclaimerView!
    
    var entity: DuplicationsEntity?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entity = entity, entity.items.count > 0 {
            setupTableView()
        } else {
            setupPlaceHolder()
        }
    }
    
    // MARK:- Private
    
    private func setupPlaceHolder() {
        placeholderView.isHidden = false
        placeHolderDisclaimer.subviews.first?.backgroundColor = .clear
        view.bringSubview(toFront: placeholderView)
    }
    
    private func setupFooter() {
        let footerView = DisclaimerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: CommonConstants.duplicationsFooterHeight))
        footerView.discalimerText = "This multiple medicine duplication search facility is designed to facilitate searching for duplications on a number of medicine pairs at any one time."
        tableView.tableFooterView = footerView
    }
    
    private func setupTableView() {
        
        setupFooter()
        
        guard let entity = entity else {
            return
        }
        
        
        Observable.just(entity.items)
            .bindTo(tableView.rx.items(cellIdentifier: DuplicationsResultTableViewCell.nameOfClass, cellType: DuplicationsResultTableViewCell.self)) { index, model, cell in
                cell.config(with: model)
            }.addDisposableTo(disposeBag)
    }
    
}

extension DuplicationsResultController {
    static func controller(_ entity: DuplicationsEntity?) -> DuplicationsResultController {
        let controller = DuplicationsResultController.controllerFromStoryboard(.interactions)
        controller.entity = entity
        controller.title = "Search Result"
        
        return controller
    }
}

