//
//  HomeController.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import RealmSwift

// MARK:- Implementation

final class HomeViewController: BaseViewController, HomeView, UITableViewDelegate, UISearchBarDelegate {

    internal var onComplete: (()->())?
    internal var onMenuItemSelect: (MenuItemSelectAction)?
    internal var onSearchItemSelect: ((SearchModuleItem) -> ())?
    
    private var searchController: SearchController?
    
    @IBOutlet weak var tableView: UITableView!
 
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "alert_s"),
                                                                 style: .plain,
                                                                 actionHandler: { [weak self] in
                                       self?.onMenuItemSelect?(.generalAlerts)
        })
        
        tableView.tableFooterView = UIView()
        setupTableView()
        setupPageHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK:- Private
    
    private func setupTableView() {
        
        let menuItemList = Observable.just(MenuType.allItems)
        
        menuItemList.bindTo(tableView.rx.items(cellIdentifier: HomeTableViewCell.nameOfClass, cellType: HomeTableViewCell.self)) { index, model, cell in
                cell.config(with: model)
            }.addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(MenuType.self).subscribe(onNext: { [weak self] (menuType) in
                self?.onMenuItemSelect?(menuType)
            }).addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
    }
    
    private func setupPageHeader() {
        
        let headerView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:CommonConstants.homeAlertsHeight))
        headerView.backgroundColor = .black
        tableView.tableHeaderView = headerView
        
        let pageController = HomeAlertsPageController.controller()
        
        addChildViewController(pageController)
        
        tableView.tableHeaderView?.addSubview(pageController.view)
        
        pageController.view?.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBar = BaseSearchBar(frame: view.frame)

        let button = UIButton(frame: searchBar.bounds)
        button.backgroundColor = UIColor.clear
        
        searchBar.addSubview(button)
        
        button
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.showSearch()
        }.addDisposableTo(disposeBag)
        
        return searchBar
    }
    
    private func showSearch() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        searchController = SearchController.controller()
        searchController?.onSearchItemSelect =  onSearchItemSelect
        guard let search = searchController  else { return }
        
        guard let items = EntitiesManager.shared.searcItems() else { return }

        search.items = items
        
        search.view.alpha = 0.0
        
        self.addChildViewController(search)
        
        self.view.addSubview(search.view)
        
        
        search.view?.snp.makeConstraints({ (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        search.searchBar.showsCancelButton = true
        
        search.searchBar
            .rx
            .cancelButtonClicked
            .subscribe { [weak self] _ in
                self?.hideSearch()
            }.addDisposableTo(self.disposeBag)
        
        UIView.animate(withDuration: 0.3, animations: {
            search.view.alpha = 1.0
        }, completion: { _ in
            search.searchBar.becomeFirstResponder()
        })
    }
    
    private func hideSearch() {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { 
                        self.searchController?.view.alpha = 0.0
        }, completion: { _ in
            self.searchController?.view.removeFromSuperview()
            self.searchController?.removeFromParentViewController()
            self.searchController = nil
        })
    }
    
}

