//
//  PageController.swift
//  BugWise
//
//  Created by olbu on 6/10/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import Realm
import RealmSwift
import RxRealm

class HomeAlertsPageController: UIPageViewController, UIPageViewControllerDelegate {
    
    private (set) var alertsArray = [AlertEntity]()
    
    let pageControl = UIPageControl()
    
    private var timer = Timer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageControl()
        
        dataSource = self
        delegate = self
        
        setViewControllers([viewControllerAtIndex(0)] as [UIViewController], direction:.forward, animated: false, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }

    
    // MARK:- UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: HomeAlertsPageController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? HomeAlertContentViewController {
                timer.invalidate()
                pageViewController.pageControl.currentPage = currentViewController.pageIndex
                runTimer()
            }
        }
    }

    // MARK:- Helpers
    
    func setupPageControl() {
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints({ (make) -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        pageControl.numberOfPages = alertsArray.count
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
    }
    
    func runTimer () {
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
            self?.updateAlert()
        })
    }
    
    func updateAlert() {
        guard let currentViewController = viewControllers?.first else {
            return
        }
        
        // Use delegate method to retrieve the next view controller
        guard let nextViewController = pageViewController(self, viewControllerAfter: currentViewController) else {
            return
        }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = (nextViewController as! HomeAlertContentViewController).pageIndex
    }
    
    func viewControllerAtIndex(_ index: NSInteger) -> HomeAlertContentViewController
    {
        // Create a new view controller and pass suitable data.
        let alertModel = (alertsArray.count > 0) ? alertsArray[index] : AlertEntity()
        
        let pageContentViewController = HomeAlertContentViewController.controller(with: alertModel, index: index) {
            self.navigationController?.pushViewController(AlertDetailedController.controller(with: alertModel), animated: true)
        }
        
        return pageContentViewController
    }
    
    
    static func controller() -> HomeAlertsPageController {
        let controller = HomeAlertsPageController.controllerFromStoryboard(.home)
        
        controller.alertsArray = EntitiesManager.shared.alerts!
        
        return controller
    }
}

extension HomeAlertsPageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: HomeAlertContentViewController = viewController as! HomeAlertContentViewController
        
        var index = pageContent.pageIndex
        
        index -= 1
        
        if ((index < 0) || (index == NSNotFound))
        {
            index = alertsArray.count - 1
        }
        
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: HomeAlertContentViewController = viewController as! HomeAlertContentViewController
        
        var index = pageContent.pageIndex
        
        index += 1
        if (index == alertsArray.count || index == NSNotFound) {
            index = 0
        }
        return viewControllerAtIndex(index)
        
    }
    
}
