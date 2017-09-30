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

class SearchController: BaseViewController, SearchView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewTopOffset: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var onSearchItemSelect: ((SearchModuleItem) -> ())?
    var onSearchBarCancelSelect: voidBlock?
    
    var items: [SearchModuleItem]?
    var isModalPresentation: Bool?
    
    private var sections = [SectionModel<String, SearchModuleItem>]()
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.sectionIndexBackgroundColor = UIColor.clear
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
            .asObservable()
            .subscribe(onNext: { [weak self] (searchText) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.sections = strongSelf.generateSections(filterText: searchText)
                strongSelf.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }
    
    
    private func generateSections(filterText: String) -> [SectionModel<String, SearchModuleItem>] {
        
        var resultArray = [SectionModel<String, SearchModuleItem>]()
        
        guard let input = items else { return resultArray }
        
        let filteredArray = filterText.characters.count > 0 ? input.filter{ ($0.title?.lowercased().contains(filterText.lowercased()))! } : input
        
        
        if filteredArray.isEmpty {
            return resultArray
        }
        
        let sections = Set(filteredArray.map{ $0.firstLetter.uppercased() }).sorted()
        for section in sections {
            let sectionModel = SectionModel(model: section, items: filteredArray.filter{ $0.firstLetter.uppercased() == section })
            
            resultArray.append(sectionModel)
        }
        
        return resultArray
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].identity
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCellIdentifier")!
        
        let searchItem = sections[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = searchItem.title?.highligtedString(self.searchBar.text)
        if let modal = self.isModalPresentation, modal == true {
            cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "add"))
        }
        
        return cell
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{ $0.identity }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = sections.map({ $0.identity }).index(of: title) else {
            return -1
        }
        return index
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        
        let searchItem = sections[indexPath.section].items[indexPath.row]
        self.onSearchItemSelect?(searchItem)
    }
}

extension SearchController {
    static func controller() -> SearchController {
        let controller = SearchController.controllerFromStoryboard(.search)
        
        return controller
    }
}
