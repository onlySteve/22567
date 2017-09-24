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

class AlertsController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        title = BusinessModel.shared.applicationState == .patient ? "Get Bug Wise" : "General Alerts"
        
        bindUI()
        
    }
    
    private func bindUI() {
        
        let alertsArray = EntitiesManager.shared.alerts!
        let alerts = Observable.just(alertsArray)
        
        alerts
            .bindTo(tableView.rx.items(cellIdentifier: AlertTableViewCell.identifier(), cellType: AlertTableViewCell.self)) { index, model, cell in
                cell.config(with: model)
            }.addDisposableTo(disposeBag)
        
        tableView
            .rx
            .modelSelected(AlertEntity.self).subscribe(onNext: { [weak self] (alert) in
                self?.navigationController?.pushViewController(AlertDetailedController.controller(with: alert), animated: true)
            }).addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)

    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AlertTableViewCell.height()
    }
}

extension AlertsController {
    static func controller() -> AlertsController {
        let controller = AlertsController.controllerFromStoryboard(.home)
        
        return controller
    }
}
