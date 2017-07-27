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

final class FavouritesViewController: BaseViewController, UITableViewDataSource {
    
    private let disposeBag = DisposeBag()
    private var dataSource = Array<BaseEntity>()
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
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
        
        var entity = dataSource[indexPath.row]
        var title: String?
        
        if entity.isKind(of: MicrobeEntity.self) {
            let microbeEntity = entity as! MicrobeEntity
            title = microbeEntity.title
        }
        
        if entity.isKind(of: InfectionEntity.self) {
            let infectionEntity = entity as! InfectionEntity
            title = infectionEntity.title
        }
        
        if entity.isKind(of: AntibioticEntity.self) {
            let antibioticEntity = entity as! AntibioticEntity
            title = antibioticEntity.heading
        }
        
        cell.textLabel?.text = title?.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "remove"))
        return cell
    }
    
    private func updateDatasource() {
        
        guard let realm = try? Realm() else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: dataSource = realm.objects(AntibioticEntity.self).filter{ $0.isFavorite == true }
            break
        case 1: dataSource = realm.objects(MicrobeEntity.self).filter{ $0.isFavorite == true }
            break
        case 2: dataSource = realm.objects(InfectionEntity.self).filter{ $0.isFavorite == true }
            break
            
        default:
            dataSource = realm.objects(AntibioticEntity.self).filter{ $0.isFavorite == true }
            break
        }
        
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
