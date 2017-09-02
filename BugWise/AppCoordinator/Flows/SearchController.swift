//
//  SearchController.swift
//  BugWise
//
//  Created by olbu on 6/13/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

import RxSwift
import RxRealmDataSources
import RxRealm
import RealmSwift
import RxDataSources
import RxCocoa

class SearchController: BaseViewController, SearchView, UITableViewDelegate {
    
    @IBOutlet weak var tableViewTopOffset: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var onSearchItemSelect: ((SearchModuleItem) -> ())?
    var onSearchBarCancelSelect: voidBlock?
    
    var items: [SearchModuleItem]?
    var isModalPresentation: Bool?
    var sectionsArray = Array<String>()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SearchModuleItem>>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let modal = self.isModalPresentation, modal == true {
            tableViewTopOffset.constant = UIApplication.shared.statusBarFrame.height
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK:- Private
    
    
    
    private func setupTableView() {
        
        dataSource.configureCell = { [unowned self] (_, tv, ip, searchItem: SearchModuleItem) in
            let cell = tv.dequeueReusableCell(withIdentifier: "searchCellIdentifier")!
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.attributedText = searchItem.title?.highligtedString(self.searchBar.text)
            
            if let modal = self.isModalPresentation, modal == true {
                cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "add"))
            }
            
            return cell
        }
        
//        dataSource.sectionForSectionIndexTitle = { title in
//            return sectionsArray.index(of: title)
//        }
//        
//        dataSource.
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            let section = dataSource[sectionIndex]
            
            return section.identity
        }
        
        tableView
            .rx
            .modelSelected(SearchModuleItem.self)
            .subscribe(onNext: { [weak self] searchItem  in
                self?.onSearchItemSelect?(searchItem)
            }).addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearch() {
        
        if let cancelBlock = onSearchBarCancelSelect {
            searchBar.showsCancelButton = true
            
            searchBar
                .rx
                .cancelButtonClicked
                .subscribe { _ in
                    cancelBlock()
                }.addDisposableTo(self.disposeBag)
        }
        
        let search = searchBar.rx.text.orEmpty.changed.asDriver().startWith("")
        
        search
            .map{ [unowned self] (searchText) in
                self.generateSections(input: self.items, filterText: searchText)
            }
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
    
    
    private func generateSections(input: [SearchModuleItem]?, filterText: String) -> [SectionModel<String, SearchModuleItem>] {
        
        var resultArray = [SectionModel<String, SearchModuleItem>]()
        sectionsArray.removeAll()
        
        guard let input = input else { return resultArray }
        
        let filteredArray = filterText.characters.count > 0 ? input.filter{ ($0.title?.lowercased().contains(filterText.lowercased()))! } : input
        
        
        if filteredArray.isEmpty {
            return resultArray
        }
        
        let sections = Set(filteredArray.map{ $0.firstLetter.uppercased() }).sorted()
        for section in sections {
            let sectionModel = SectionModel(model: section, items: filteredArray.filter{ $0.firstLetter.uppercased() == section })

            sectionsArray.append(sectionModel.identity)
            resultArray.append(sectionModel)
        }
        
        return resultArray
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionsArray
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return sectionsArray.index(of: title)!
        
    }// tell table which section corresponds to section title/index (e.g. "B",1))

    
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView  {
            headerView.textLabel?.textColor = CommonAppearance.lighBlueColor
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension SearchController {
    static func controller() -> SearchController {
        let controller = SearchController.controllerFromStoryboard(.search)
        
        return controller
    }
}
