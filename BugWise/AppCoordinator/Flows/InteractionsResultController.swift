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
import ObjectMapper

class InteractionsResultController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var placeholderView: DefaultBGView!
    
    @IBOutlet weak var placeholderBackButton: UIButton!
    @IBOutlet weak var placeHolderDisclaimer: DisclaimerView!
    @IBOutlet weak var tableView: UITableView!
    
    var entities: [InteractionsEntity]?
    
    private var dataSource = Array<Mappable>()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let entities = entities, entities.count > 0 {
            setupTableView()
        } else {
            setupPlaceHolder()
        }
    }
    
    // MARK:- Private
    
    private func setupPlaceHolder() {
        placeholderView.isHidden = false
        placeHolderDisclaimer.subviews.first?.backgroundColor = .clear
        
        placeholderBackButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).addDisposableTo(disposeBag)
        
        view.bringSubview(toFront: placeholderView)
    }
    
    
    private func setupFooter() {
        let footerView = DisclaimerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: CommonConstants.interactionsFooterHeight))
        
        footerView.separatorColor = CommonAppearance.duplicationsSeparatorColor
        
        footerView.discalimerText = "This multiple medicine interaction search facility is designed to facilitate searching for interactions on a number of medicine pairs at any one time. Studies of medicines interactions are generally conducted for two medicine pairs. This multiple medicine interaction checker allows a single search for a number of medicine pairs as a single search. The compatibility of three or more medicines in combination is not generally available."
        
        tableView.tableFooterView = footerView
    }
    
    private func setupTableView() {
        
        guard let entities = entities else {
            return
        }
        
        setupFooter()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dataSource = generateDatasource(input: entities)
        
        tableView.reloadData()
    }
    
    private func generateDatasource(input: [InteractionsEntity]) -> Array<Mappable> {
        
        var resultArray = Array<Mappable>()
        
        for item in input {
            resultArray.append(item)
            resultArray += item.details as Array<Mappable>
        }
        
        return resultArray
    }
    
    // MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = dataSource[indexPath.row]
        
        if item is InteractionsEntity {
            let cell: InteractionsResultHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: InteractionsResultHeaderTableViewCell.nameOfClass) as! InteractionsResultHeaderTableViewCell
            
            let sepVisible = (dataSource.count > indexPath.row + 1) ? dataSource[indexPath.row + 1] is InteractionsEntity : true
            cell.config(with: item as! InteractionsEntity, separatorVisible: (indexPath.row + 1 == dataSource.count) ? false : sepVisible)
            
            return cell
        }
        
        if item is InteractionsDetailEntity {
            let cell: InteractionsResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: InteractionsResultTableViewCell.nameOfClass) as! InteractionsResultTableViewCell
            
            let sepVisible = (dataSource.count > indexPath.row + 1) ? dataSource[indexPath.row + 1] is InteractionsEntity : true
            cell.config(with: item as! InteractionsDetailEntity, separatorVisible: (indexPath.row + 1 == dataSource.count) ? false : sepVisible)
            
            return cell
        }
        
        return UITableViewCell()
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
    static func controller(_ entities: [InteractionsEntity]?) -> InteractionsResultController {
        let controller = InteractionsResultController.controllerFromStoryboard(.interactions)
        controller.entities = entities
        controller.title = "Search Result"
        
        return controller
    }
}


