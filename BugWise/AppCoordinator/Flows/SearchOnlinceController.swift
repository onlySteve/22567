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


class SearchOnlinceController: BaseViewController, UITableViewDelegate {
    
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
                .map{ (searchResult) in
                    return strongSelf.generateSections(input: searchResult)
                }
                .bindTo(strongSelf.tableView.rx.items(dataSource: strongSelf.dataSource))
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchOnlinceController {
    static func controller() -> SearchOnlinceController {
        let controller = SearchOnlinceController.controllerFromStoryboard(.search)
        
        return controller
    }
}
