//
//  SearchOnlinceController.swift
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
import Moya


class SearchOnlinceController: BaseViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewTopOffset: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var type: SearchType = .antimicrobial
    var isModalPresentation: Bool?
    
    var onSearchBarCancelSelect: voidBlock?
    var onSearchItemSelect: ((SearchModuleItem) -> ())?
    var needToShowOfflineData = false
    
    private var provider: RxMoyaProvider<API>!
    private var searchTrackerModel: SearchTrackerModel!
    
    private var latestSearchText: Observable<String> {
        return searchBar.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }

    private let disposeBag = DisposeBag()
    private var sections = [SectionModel<String, SearchModuleItem>]()
    
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
        
        BusinessModel.shared.performActionWitValidToken { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            // First part of the puzzle, create our Provider
            strongSelf.provider = RxMoyaProvider<API>(endpointClosure: EntitiesManager.shared.endpointClosure)
            
            // Now we will setup our model
            strongSelf.searchTrackerModel = SearchTrackerModel(provider: strongSelf.provider, text: strongSelf.latestSearchText, type: strongSelf.type, needToShowOfflineData: strongSelf.needToShowOfflineData)
            
            // And bind issues to table view
            // Here is where the magic happens, with only one binding
            // we have filled up about 3 table view data source methods
            strongSelf.searchTrackerModel
                .trackItems()
                .asObservable()
                .subscribe(onNext: { (searchResult) in
                    strongSelf.sections = strongSelf.generateSections(input: searchResult)
                    strongSelf.tableView.reloadData()
                })
                .addDisposableTo(strongSelf.disposeBag)
            
            if strongSelf.isModalPresentation == false && strongSelf.onSearchBarCancelSelect == nil {
                return
            }
            
            if let cancelBlock = strongSelf.onSearchBarCancelSelect {
                strongSelf.searchBar.showsCancelButton = true
                
                strongSelf.searchBar
                    .rx
                    .cancelButtonClicked
                    .subscribe { _ in
                        cancelBlock()
                    }.addDisposableTo(strongSelf.disposeBag)
            }
        }
    }
    
    
    private func generateSections(input: [SearchModuleItem]?) -> [SectionModel<String, SearchModuleItem>] {
        
        var resultArray = [SectionModel<String, SearchModuleItem>]()
        
        guard let input = input else { return resultArray }
        
        
        let sections = Set(input.map{ $0.firstLetter.uppercased() }).sorted()
        for section in sections {
            let sectionModel = SectionModel(model: section, items: input.filter{ $0.firstLetter.uppercased() == section })
            
            resultArray.append(sectionModel)
        }
        
        return resultArray
    }
    

    // MARK: - Table view data source
    
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
        return self.isModalPresentation == true ? nil : sections.map{ $0.identity }
    }
    
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

extension SearchOnlinceController {
    static func controller() -> SearchOnlinceController {
        let controller = SearchOnlinceController.controllerFromStoryboard(.search)
        
        return controller
    }
}
