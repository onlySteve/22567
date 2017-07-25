//
//  InteractionsController.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift
import RxGesture
import RxDataSources

class InteractionsController: BaseViewController, UITableViewDelegate {
    
    var type: SearchType?
    
    private let resultItems = Variable(Array<SearchEntity>())
    
    @IBOutlet weak var titleView: CommonTitleHeaderView!
    @IBOutlet weak var searchButton: BaseButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViewAccordingType()
        setupSearchBar()
        setupTableView()
        setupSearchButton()
    }
    
    // MARK:- Private
    
    private func setupViewAccordingType() {
        
        guard let type = type else {
            return
        }
        
        switch type {
        case .antimicrobial:
            titleView.image = #imageLiteral(resourceName: "duplicate_w")
            titleView.title = "Add two or more medicines to the search bar to check for antibiotic duplications"
            searchButton.setTitle("Search for Duplications", for: .normal)
            break
        case .medicine:
            titleView.title = "Add two or more medicines to the search bar to check for medicine interactions"
            titleView.image = #imageLiteral(resourceName: "antibiotic_w")
            searchButton.setTitle("Search for Interactions", for: .normal)
            break
        }
        
    }
    
    private func setupSearchBar() {
        let button = UIButton(frame: searchBar.bounds)
        button.backgroundColor = UIColor.clear
        
        searchBar.addSubview(button)
        
        button
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.showSearch()
            }.addDisposableTo(disposeBag)
    }
    
    private func showSearch() {
        let searchController = SearchOnlinceController.controller()
        
        if let type = type {
            searchController.type = type
        }
        
        searchController.isModalPresentation = true
        
        searchController.onSearchBarCancelSelect = {
            searchController.dismiss(animated: true, completion: nil)
        }
        
        searchController.onSearchItemSelect = { [weak self] (searchItem) in
            
            searchController.dismiss(animated: true, completion: {
                self?.resultItems.value.append(searchItem)
            })
        }
        
        present(searchController, animated: true, completion: {
            searchController.searchBar.becomeFirstResponder()
        })
    }
    
    private func updateSearchButton() {
        
        if resultItems.value.count > 1 {
            searchButton.isUserInteractionEnabled = true
            searchButton.setBackgroundColor(color: CommonAppearance.redColor,
                                            forState: .normal)
            searchButton.setBackgroundColor(color: CommonAppearance.redColor.withAlphaComponent(0.7),
                                            forState: .highlighted)
        } else {
            searchButton.isUserInteractionEnabled = false
            searchButton.setBackgroundColor(color: CommonAppearance.greyColor,
                                            forState: .normal)
        }
    }
    
    private func setupSearchButton() {
        
        resultItems.asObservable().startWith([SearchEntity]()).subscribe { [weak self] _ in
            self?.updateSearchButton()
        }.addDisposableTo(disposeBag)
        
        
        searchButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                
                guard let type = self?.type else { return }
                showHud()
                switch type {
                case .medicine:
                    EntitiesManager.shared.interactionsSearch((self?.resultItems.value.map{ $0.id ?? "" })!,
                                                              onSuccess: { (interactionEntity) in
                                                                hideHud()
                                                                self?.navigationController?.pushViewController(InteractionsResultController.controller(interactionEntity), animated: true)
                    }, onFail: {
                        showHud(success: false, time: 0.5, message: "Please, try again", completion: nil)
                    })
                case .antimicrobial:
                    EntitiesManager.shared.duplicationsSearch((self?.resultItems.value.map{ $0.id ?? "" })!,
                                                              onSuccess: { (duplicationsEntity) in
                                                                hideHud()
                                                                self?.navigationController?.pushViewController(DuplicationsResultController.controller(duplicationsEntity), animated: true)
                    }, onFail: {
                        showHud(success: false, time: 0.5, message: "Please, try again", completion: nil)
                    })
                }
            }).addDisposableTo(disposeBag)
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        resultItems
            .asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "InteractionTableViewCell", cellType: UITableViewCell.self)) { index, model, cell in
                cell.textLabel?.text = model.title
                cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "remove"))
                
            }.addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            self?.resultItems.value.remove(at: indexPath.row)
        }).addDisposableTo(disposeBag)
    }
    
}

extension InteractionsController {
    static func duplicationsController() -> InteractionsController {
        let controller = InteractionsController.controllerFromStoryboard(.interactions)
        controller.type = .antimicrobial
        controller.title = MenuType.duplications.title
        return controller
    }
    
    static func interactionsController() -> InteractionsController {
        let controller = InteractionsController.controllerFromStoryboard(.interactions)
        controller.type = .medicine
        controller.title = MenuType.interactions.title
        return controller
    }
}
