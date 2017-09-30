//
//  Alerts.swift
//  BugWise
//
//  Created by olbu on 6/5/17.
//  Copyright © 2017 olbu. All rights reserved.
//


import UIKit

typealias AlertAction = () -> ()?

//MARK: - ALERTS
func alertWith(title: String, message: String, okAction: @escaping AlertAction) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        okAction()
    })
    return alert
}

func alertWithError(error: NSError?, okAction: @escaping AlertAction) -> UIAlertController {
    var title: String = "Error"
    var message: String = "Unexpected error. Please try again."
    
    if let error = error {
        title = error.localizedDescription
        message = error.localizedFailureReason ?? ""
        if let recoverySuggestion = error.localizedRecoverySuggestion {
            message += "\n\(recoverySuggestion)"
        }
    }
    return alertWith(title: title, message: message, okAction: okAction)
}

func alertWith(title: String, message: String, okTitle: String, okAction: @escaping AlertAction) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: okTitle, style: .default) { _ in
        okAction()
    })
    return alert
}

//func alertWith(title: String, message: String, okTitle: String = "OK", okAction: @escaping AlertAction, cancelTitle: String = "Cancel", cancelAction: @escaping AlertAction) -> UIAlertController {
//    
//    let okAlertAction = UIAlertAction(title: okTitle, style: .default) { _ in
//        okAction()
//    }
//    
//    let cancelAlertAction = (UIAlertAction(title: cancelTitle, style: .cancel) { _ in
//        cancelAction()
//    }
//        
//    let alert = alert(withTitle: title, message: message, actions: [okAlertAction, cancelAlertAction], style:.alert)
//    
//    return alert
//}

func alert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
        
    })
    return alert
}

func alert(withTitle: String = "", message: String = "", actions: [UIAlertAction], style: UIAlertControllerStyle)  -> UIAlertController {
    let alert = UIAlertController(title: withTitle, message: message, preferredStyle: style)
    
    actions.forEach{ alert.addAction($0) }
    
    return alert
    
}

func actionSheet(withTitle: String = "", message: String = "", actions: [UIAlertAction], style: UIAlertControllerStyle)  -> UIAlertController {
    let alert = UIAlertController(title: withTitle, message: message, preferredStyle: .actionSheet)
    
    actions.forEach{ alert.addAction($0) }
    
    return alert
    
}

public var onAgreeButtonAction: (() -> ())?
public var onDisAgreeButtonAction: (() -> ())?

func showPreviewDisclaimerAlert() {
    showDisclaimerAlert(preview: true, agreeAction: nil, disagreeAction: nil)
}

func showDisclaimerAlert(preview: Bool = false, agreeAction: (() -> ())? = nil, disagreeAction: (() -> ())? = nil) {
    
    guard let window = UIApplication.shared.keyWindow else { return }
    
    let disclaimerController = DisclaimerViewController.controller()
    
    disclaimerController.preview = preview
    disclaimerController.view.frame = window.frame
    
    window.addSubview(disclaimerController.view)
    
    disclaimerController.view.snp.makeConstraints { (make) ->() in
        make.size.equalToSuperview()
        make.center.equalToSuperview()
    }
    
    disclaimerController.onAgreeButtonAction = agreeAction
    disclaimerController.onDisAgreeButtonAction = disagreeAction
    
    disclaimerController.showAnimated()
}

func showNotificationAlert(_ data: [AnyHashable : Any]) {
    
    guard let notification = data["aps"] as? [String: Any] else { return }
    
    guard let text = notification["alert"] as? String else { return }
    
    guard let window = UIApplication.shared.keyWindow else { return }
    
    let notificationAlert = alert(title: "Notification", message: text)
    
    window.currentViewController()?.present(notificationAlert, animated: true, completion: nil)
}

func showLocalNotificationAlert(title: String?, message: String?) {
    
    guard let window = UIApplication.shared.keyWindow else { return }
    let notificationAlert = alert(title: title ?? "", message: message ?? "")
    
    window.currentViewController()?.present(notificationAlert, animated: true, completion: nil)
}
