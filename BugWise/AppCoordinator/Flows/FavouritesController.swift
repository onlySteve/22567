//
//  FavouritessController.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxCocoa
import RxSwift
import RealmSwift
import RxGesture

final class FavouritesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let disposeBag = DisposeBag()
    private var dataSource = Array<SearchModuleItem>()
    
    var onItemSelect: ((SearchModuleItem) -> ())?
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        
        title = "Favourites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDatasource()
    }
    
    // MARK: -Private
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        updateDatasource()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath)
        
        let entity = dataSource[indexPath.row]
        
        cell.textLabel?.text = entity.title
        cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "remove"))
        cell.accessoryView?
            .rx
            .tapGesture()
            .when(.recognized).subscribe{ [weak self] _  in
            EntitiesManager.shared.updateEntity(entity, favStatus: false)
            self?.updateDatasource()
            }.addDisposableTo(disposeBag)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onItemSelect?(dataSource[indexPath.row])
    }
    
    private func updateDatasource() {
        
        var type = ModuleSearchType.drug
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: type = .drug
            break
        case 1: type = .microbe
            break
        case 2: type = .condition
            break
            
        default:
            break
        }
        
        guard let entities = EntitiesManager.shared.searcItems(type: type) else {
            placeholderView.isHidden = false
            view.bringSubview(toFront: placeholderView)
            return
        }
        
        dataSource = entities.filter{ $0.isFavorite == true }
        
        if dataSource.count > 0 {
            tableView.reloadSections([0], with: .fade)
            placeholderView.isHidden = true
        } else {
            placeholderView.isHidden = false
            view.bringSubview(toFront: placeholderView)
        }
    }
}

extension FavouritesViewController {
    static func controller() -> FavouritesViewController {
        let controller = FavouritesViewController.controllerFromStoryboard(.tabBar)
        
        return controller
    }
}
