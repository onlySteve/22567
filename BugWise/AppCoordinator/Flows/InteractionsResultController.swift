//
//  InteractionsResultController.swift
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

class InteractionsResultController: BaseViewController, UITableViewDelegate {
    @IBOutlet weak var placeholderView: DefaultBGView!
    
    var entity: InteractionsEntity?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let entity = entity, entity.details.count > 0 {
            setupTableView()
        } else {
            setupPlaceHolder()
        }
    }
    
    // MARK:- Private
    
    private func setupPlaceHolder() {
        placeholderView.isHidden = false
        view.bringSubview(toFront: placeholderView)
    }
    
    private func setupHeader() {
        
        let headerView = InteractionsResultHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: CommonConstants.interactionsFooterHeight))
        tableView.tableHeaderView = headerView
        
        headerView.config(firstItem: entity?.firstMedcine, secondItem: entity?.secondMedcine, image: entity?.severityType?.image, description: entity?.severityType?.title)
        
    }
    
    private func setupFooter() {
        let footerView = DisclaimerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: CommonConstants.interactionsFooterHeight))
        tableView.tableFooterView = footerView
        
        
        footerView.discalimerText = "This multiple medicine interaction search facility is designed to facilitate searching for interactions on a number of medicine pairs at any one time. Studies of medicines interactions are generally conducted for two medicine pairs. This multiple medicine interaction checker allows a single search for a number of medicine pairs as a single search. The compatibility of three or more medicines in combination is not generally available."
    }
    
    private func setupTableView() {
        
        guard let entity = entity else {
            return
        }
        
        setupHeader()
        setupFooter()
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        Observable.just(entity.details)
            .bindTo(tableView.rx.items(cellIdentifier: InteractionsResultTableViewCell.nameOfClass, cellType: InteractionsResultTableViewCell.self)) { index, model, cell in
                cell.config(with: model)
            }.addDisposableTo(disposeBag)
    }
 
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension InteractionsResultController {
    static func controller(_ entity: InteractionsEntity?) -> InteractionsResultController {
        let controller = InteractionsResultController.controllerFromStoryboard(.interactions)
        controller.entity = entity
        controller.title = "Search Result"
        
        return controller
    }
}


