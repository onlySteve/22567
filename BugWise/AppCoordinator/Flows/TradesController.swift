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


class TradesController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var patientHeaderView: UIView!
    
    var items = List<TradeEntity>()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        if BusinessModel.shared.applicationState == .patient {
            headerView.isHidden = true
            headerHeight.constant = 30
        } else {
            patientHeaderView.isHidden = true
        }
        
        title = "Trades"
        navigationItem.backBarButtonItem?.title = "Back"
        
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        bindUI()
        
    }
    
    private func bindUI() {
        
        if items.count == 0 { return }
        
        let itemsObservable = Observable.just(generatePriceList(trades: items))
        
        itemsObservable.bindTo(tableView.rx.items(cellIdentifier: TradeTableViewCell.identifier(), cellType: TradeTableViewCell.self)) { index, model, cell in
            cell.config(with: model)
            }.addDisposableTo(disposeBag)
    }
        
    private func generatePriceList(trades: List<TradeEntity>) -> Array<TradeStruct> {
        var resultArray = Array<TradeStruct>()
        
        let sortedTrades = trades.toArray().sorted(by: { $0.priority < $1.priority })
        
        for trade in sortedTrades {
            if BusinessModel.shared.applicationState == .patient {
                resultArray.append(TradeStruct(title: trade.title ?? "",
                                               size: "",
                                               price: "",
                                               manuf: trade.manuf ?? "",
                                               strength: trade.strength ?? "",
                                               form: trade.form ?? ""))
            } else {
                for price in trade.price {
                    resultArray.append(TradeStruct(title: trade.title ?? "",
                                                   size: price.packageSize ?? "--",
                                                   price: price.price ?? "",
                                                   manuf: trade.manuf ?? "",
                                                   strength: trade.strength ?? "",
                                                   form: trade.form ?? ""))
                }
            }
        }
        
        return resultArray
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
        
}

extension TradesController {
    static func controller(items:List<TradeEntity>) -> TradesController {
        let controller = TradesController.controllerFromStoryboard(.search)
        controller.items = items
        return controller
    }
}
