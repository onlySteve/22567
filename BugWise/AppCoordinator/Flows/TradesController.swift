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
    
    var items = List<TradeEntity>()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trades"
        
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        bindUI()
        
    }
    
    private func bindUI() {
        
        if items.count == 0 { return }
        
        let itemsObservable = Observable.just(generatePriceList(trades: items))
        
        itemsObservable.bindTo(tableView.rx.items(cellIdentifier: TradeTableViewCell.nameOfClass, cellType: TradeTableViewCell.self)) { index, model, cell in
            cell.config(with: model)
            }.addDisposableTo(disposeBag)
    }
        
    private func generatePriceList(trades: List<TradeEntity>) -> Array<TradeStruct> {
        var resultArray = Array<TradeStruct>()
        
        for trade in trades {
            
            let title = String(format: "%@ %@ %@\n(%@)", trade.title ?? "", trade.strength ?? "", trade.form ?? "", trade.manuf ?? "")
            
            for price in trade.price {
                resultArray.append(TradeStruct(title: title, size: price.packageSize ?? "--", price: price.price ?? ""))
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
