//
//  SurveillanceDetailController.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxRealmDataSources
import RxRealm
import RealmSwift
import RxDataSources
import RxCocoa

class SurveillanceDetailController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var microbeLabel: UILabel!
    @IBOutlet weak var antibioticLabel: UILabel!
    @IBOutlet weak var sectorLocationLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeHolderView: UIView!
    
    var items: [SurveillanceEntity]?
    var requestEntity: SurveillanceRequestEntity?
    
    private var generatedSections: [SectionModel<String, SurveillanceEntity>]?
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SurveillanceEntity>>()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTitleView()
        setupTableView()
    }

    // MARK:- Private
    
    private func setupTitleView() {
        
        microbeLabel.text = requestEntity?.microbe?.title
        
        antibioticLabel.text = requestEntity?.antibiotic?.title
        antibioticLabel.textColor = CommonAppearance.blueColor
        
        sectorLocationLabel.text = String(format: "%@ sector\n%@", (requestEntity?.sector)!, (requestEntity?.location)!)
        sectorLocationLabel.textColor = CommonAppearance.boldGreyColor
    }
    
    private func setupTableView() {
        
        guard let items = items, items.count > 0 else {
            placeHolderView.isHidden = false
            view.bringSubview(toFront: placeHolderView)
            return
        }
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        placeHolderView.isHidden = true
        

        dataSource.configureCell = { (_, tv, ip, survEntity: SurveillanceEntity) in
            let cell = tv.dequeueReusableCell(withIdentifier: SurveillanceTableViewCell.nameOfClass)! as! SurveillanceTableViewCell
            
            cell.config(with: survEntity)
            return cell
        }
        
        generatedSections = generateSections(input: items)
        
        if let generatedSections = generatedSections {
            let itemsObserver = Observable.just(generatedSections)
            
            
            itemsObserver.bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
        }
        
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let section = generatedSections?[section] else { return nil }
        
        let headerView = SurveillanceTableViewHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CommonConstants.surveillanceHeaderHeight))
        headerView.titleLabel.text = String(format: "SampleType: %@", section.items.first?.sampleType ?? "None")
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CommonConstants.surveillanceHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let section = generatedSections?[section] else { return nil }
        
        let footerView = SurveillanceTableViewFooter(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CommonConstants.surveillanceFooterHeight))
        footerView.noteLabel.text = String(format: "Note: %@", section.items.first?.note ?? "")
        footerView.sourceLabel.text = String(format: "Source: %@", section.items.first?.source ?? "")
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CommonConstants.surveillanceFooterHeight
    }
    
    private func generateSections(input: [SurveillanceEntity]) -> [SectionModel<String, SurveillanceEntity>] {
        
        var resultArray = [SectionModel<String, SurveillanceEntity>]()
        
        let sections = Set(input.map{ $0.sampleType ?? "None" }).sorted()
        for section in sections {
            let sectionModel = SectionModel(model: section, items: input.filter{ ($0.sampleType ?? "None") == section })
            
            resultArray.append(sectionModel)
        }
        
        return resultArray
    }
}

extension SurveillanceDetailController {
    static func controller() -> SurveillanceDetailController {
        let controller = SurveillanceDetailController.controllerFromStoryboard(.surveillance)
        
        return controller
    }
}
