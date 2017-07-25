//
//  AlertsController.swift
//  BugWise
//
//  Created by olbu on 6/10/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RealmSwift

import RxSwift
import RxCocoa
import RxRealm
import RxRealmDataSources

class AlertsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        title = "General Alerts"
        
        bindUI()
        
    }
    
    private func bindUI() {
        
        let alertsArray = EntitiesManager.shared.alerts!
        let alerts = Observable.just(alertsArray)
        
        alerts
            .bindTo(tableView.rx.items(cellIdentifier: AlertTableViewCell.nameOfClass, cellType: AlertTableViewCell.self)) { index, model, cell in
                cell.config(with: model)
            }.addDisposableTo(disposeBag)
        
        tableView
            .rx
            .modelSelected(AlertEntity.self).subscribe(onNext: { [weak self] (alert) in
                self?.navigationController?.pushViewController(AlertDetailedController.controller(with: alert), animated: true)
            }).addDisposableTo(disposeBag)

    }
}

extension AlertsController {
    static func controller() -> AlertsController {
        let controller = AlertsController.controllerFromStoryboard(.home)
        
        return controller
    }
}
