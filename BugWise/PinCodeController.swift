//
//  PinCodeController.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MessageUI

final class PinCodeViewController: UIViewController, PinCodeView {

    struct RequestKey {
        static let recipients = ["info@pharmadynamics.co.za"]
        static let subject = "Request a Bug Wise code"
        static let message = "I am interested in obtaining access to the Bug Wise application.\nI am a doctor/nurse/pharmacist/other: ___________________________\nMy healthcare provider registration body number is: ___________________________\nMy contact number is: ___________________________\nNote to provider: these details are required for verification purposes to obtain a Bug Wise access code."
    }
    
    // MARK:- Controller handler
    internal var onComplete: ((String) -> ())?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var hintLabel: BaseLabel!
    @IBOutlet weak var signInButton: BaseOrangeButton!
    
    @IBOutlet weak var requestCodeButton: BaseRedButton!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        hintLabel.textColor = CommonAppearance.blueColor
        
        //TODO:- Remove it
        searchTextField.text = "04E4523A6C45C287"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
        
        signInButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.onComplete?(self?.searchTextField.text! ?? "")
            }).addDisposableTo(disposeBag)
        
        requestCodeButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.requsetCode()
            }).addDisposableTo(disposeBag)
        
        textFieldSetup()
    }

    
    // MARK:- Private
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        if searchTextField.isFirstResponder {
            view.endEditing(false)
        }
    }
    
    private func requsetCode() {
        if !MFMailComposeViewController.canSendMail() {
            let errorAlert = alert(title: "Error", message: "You can not send mail. Please, setup your email in Settings and try again.")
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(RequestKey.recipients)
        composeVC.setSubject(RequestKey.subject)
        composeVC.setMessageBody(RequestKey.message, isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    private func textFieldSetup() {
        
        let searchImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 30, height: searchTextField.frame.height))
        searchImageView.contentMode = .center
        searchImageView.image = UIImage(named: "search_s")
        
        searchTextField.leftView = searchImageView
        searchTextField.leftViewMode = .always
        searchTextField.textColor = CommonAppearance.blueColor
        searchTextField.layer.backgroundColor = CommonAppearance.lightGreyColor.cgColor
        searchTextField.layer.cornerRadius = 6.5
        searchTextField.layer.masksToBounds = true
        
        searchTextField.rx
            .controlEvent([.editingDidEndOnExit])
            .subscribe(onNext:{ [weak self] in 
                self?.onComplete?(self?.searchTextField.text! ?? "")
            })
            .addDisposableTo(disposeBag)
    }
}

extension PinCodeViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
