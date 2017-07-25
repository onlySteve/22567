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
    var onSearchItemSelect: ((SearchEntity) -> ())?
    
    private var provider: RxMoyaProvider<API>!
    private var searchTrackerModel: SearchTrackerModel!
    
    private var latestSearchText: Observable<String> {
        return searchBar.rx.text
            .orEmpty
            .skipWhile{ $0.characters.count < 3 }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }

    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SearchEntity>>()
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
        
        dataSource.configureCell = { [unowned self] (_, tv, ip, searchItem: SearchEntity) in
            let cell = tv.dequeueReusableCell(withIdentifier: "searchCellIdentifier")!
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
            .modelSelected(SearchEntity.self)
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
        
        // First part of the puzzle, create our Provider
        provider = RxMoyaProvider<API>(endpointClosure: EntitiesManager.shared.endpointClosure)
        
        // Now we will setup our model
        searchTrackerModel = SearchTrackerModel(provider: provider, text: latestSearchText, type: type)
        
        // And bind issues to table view
        // Here is where the magic happens, with only one binding
        // we have filled up about 3 table view data source methods
        
//        Observable.just([SectionModel(model: "Ras", items: [SearchEntity]())]).bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
        searchTrackerModel
            .trackItems()
            .map{ (searchResult) in
                return self.generateSections(input: searchResult)
            }
            .bindTo(tableView.rx.items(dataSource: dataSource))
//            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        // Here we tell table view that if user clicks on a cell,
        // and the keyboard is still visible, hide it
        tableView
            .rx.itemSelected
            .subscribe(onNext: { indexPath in
//                if self.searchBar.isFirstResponder == true {
//                    self.view.endEditing(true)
//                }
            })
            .addDisposableTo(disposeBag)

        
//        let search = searchBar.rx.text.orEmpty.changed.asDriver().startWith("")
//        
//        search
//            .map{ [unowned self] (searchText) in
//                EntitiesManager.shared.searchOnline(SearchOnlineRequestEntity(text: searchText, type: type), onSuccess: { (searchArray) in
//                    return self.generateSections(input: searchArray, filterText: searchText)
//                }, onFail: {
//                    return [SectionModel<String, SearchEntity>]()
//                })
//            }
//            .drive(tableView.rx.items(dataSource: dataSource))
//            .addDisposableTo(disposeBag)
    }
    
    
    private func generateSections(input: [SearchEntity]?) -> [SectionModel<String, SearchEntity>] {
        
        var resultArray = [SectionModel<String, SearchEntity>]()
        
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
}

extension SearchOnlinceController {
    static func controller() -> SearchOnlinceController {
        let controller = SearchOnlinceController.controllerFromStoryboard(.search)
        
        return controller
    }
}

