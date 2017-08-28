//
//  ProfileController.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SVProgressHUD
import RealmSwift
import SnapKit

fileprivate typealias BindBlock = (String) -> Void

// MARK:- Implementation

final class ProfileViewController: BaseViewController, ProfileView {
    
    internal var onComplete: (()->())?
    internal var onBack: (()->())?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var usrNameInput: ProfileTextField!
    @IBOutlet weak var surNameInput: ProfileTextField!
    @IBOutlet weak var phoneInput: ProfileTextField!
    @IBOutlet weak var mailInput: ProfileTextField!
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var userTypeButton: UIButton!
    @IBOutlet weak var sectorTypeButton: UIButton!
    
    @IBOutlet weak var workInHospitalSwitch: ProfileSwitchView!
    @IBOutlet weak var notificationSwitch: ProfileSwitchView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup nav bar buttons
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .plain,
                                                                 actionHandler: { [weak self] in
                                                                    self?.showDisclaimer()
                                                                })
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        contentView.addGestureRecognizer(tap)
        
        setupExistingData()
        
        BusinessModel.shared.usr.loggedIn
            .asObserver()
            .distinctUntilChanged()
            .subscribe { value in
            
                guard let value = value.element else { return }
                
                if value {
                     self.navigationItem.leftBarButtonItem = nil
                    self.navigationItem.rightBarButtonItem = nil
//                   self.setupExistedData()
                } else {
                    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                                           style: .plain,
                                                                           actionHandler: { [weak self] in
                                                                            self?.onBack?()
                    })
                    
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                             style: .plain,
                                                                             actionHandler: { [weak self] in
                                                                                self?.showDisclaimer()
                    })
                }
            }
            .addDisposableTo(disposeBag)
        
//        if BusinessModel.shared.usr.loggedIn.value {
//            setupExistedData()
//        } else {
//            s
//        }
        
        bindUI()
    }
    
    
    // MARK:- Private
    
    private func setupExistingData() {
        usrNameInput.textField.text = BusinessModel.shared.usr.userName.value
        surNameInput.textField.text = BusinessModel.shared.usr.sureName.value
        
        phoneInput.textField.text = BusinessModel.shared.usr.phone.value
        mailInput.textField.text = BusinessModel.shared.usr.mail.value
        
        
        locationButton.setTitle(BusinessModel.shared.usr.location.value.rawValue, for: .normal)
        userTypeButton.setTitle(BusinessModel.shared.usr.userType.value.rawValue, for: .normal)
        sectorTypeButton.setTitle(BusinessModel.shared.usr.sector.value.rawValue, for: .normal)

        workInHospitalSwitch.switchItem.isOn = BusinessModel.shared.usr.workInHospital.value
        notificationSwitch.switchItem.isOn = BusinessModel.shared.usr.notificationsEnabled.value
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
            view.endEditing(false)
    }
    
    private func bindUI() {
        
        phoneInput.textField.keyboardType = .phonePad
        mailInput.textField.keyboardType = .emailAddress
        
        usrNameInput.textField.autocapitalizationType = .words
        surNameInput.textField.autocapitalizationType = .words
        
        BusinessModel.shared.usr.loggedIn
            .asObservable()
            .distinctUntilChanged()
            .filter({ $0 == true })
            .subscribe { [weak self] in
                self?.navigationItem.leftBarButtonItem = nil
            }
            .addDisposableTo(disposeBag)
        
        locationButton.setTitle(BusinessModel.shared.usr.location.value.rawValue, for: .normal)
        userTypeButton.setTitle(BusinessModel.shared.usr.userType.value.rawValue, for: .normal)
        sectorTypeButton.setTitle(BusinessModel.shared.usr.sector.value.rawValue, for: .normal)
        
        usrNameInput.textField
            .rx
            .text
            .orEmpty
            .bindNext { text in
                BusinessModel.shared.usr.userName.value = text
            }.addDisposableTo(disposeBag)
        
        surNameInput.textField
            .rx
            .text
            .orEmpty
            .bindNext { text in
                BusinessModel.shared.usr.sureName.value = text
            }.addDisposableTo(disposeBag)
        
        phoneInput.textField
            .rx
            .text
            .orEmpty
            .bindNext { text in
                BusinessModel.shared.usr.phone.value = text
            }.addDisposableTo(disposeBag)
        
        mailInput.textField
            .rx
            .text
            .orEmpty
            .bindNext{ text in
                BusinessModel.shared.usr.mail.value = text
            }.addDisposableTo(disposeBag)
        
        workInHospitalSwitch.switchItem
            .rx
            .isOn
            .bindNext { isOn in
                BusinessModel.shared.usr.workInHospital.value = isOn
        }.addDisposableTo(disposeBag)
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "description_y"))
        
        let notificationButton = UIButton(frame: imageView.frame)
        
        notificationButton.setImage(#imageLiteral(resourceName: "description_y"), for: .normal)
        
        
        notificationButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                let notificationsAlert = alert(title: "Notifications", message: "We need this information if you would like to be informed about general alerts")
                self?.present(notificationsAlert, animated: false, completion: nil)
            }).addDisposableTo(disposeBag)
        
        notificationSwitch.addSubview(notificationButton)
        
        notificationButton.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(notificationSwitch.titleLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        })

        
        notificationSwitch.switchItem
            .rx
            .isOn
            .bindNext { isOn in
                BusinessModel.shared.usr.notificationsEnabled.value = isOn
            }.addDisposableTo(disposeBag)
        
        
        bindButton(button: userTypeButton, array: UserType.allValues.map{ $0.rawValue }, actionSheetTitle: "Select User type") { (str) in
            BusinessModel.shared.usr.userType.value = UserType(rawValue:str)!
        }
        
        bindButton(button: sectorTypeButton, array: Sector.profileArray.map{ $0.rawValue }, actionSheetTitle: "Select Sector type") { (str) in
            BusinessModel.shared.usr.sector.value = Sector(rawValue:str)!
        }
        
        bindButton(button: locationButton, array: Location.allValues.map{ $0.rawValue }, actionSheetTitle: "Select Location") { (str) in
            BusinessModel.shared.usr.location.value = Location(rawValue:str)!
        }
    }
    
    private func showDisclaimer() {
        
        view.endEditing(false)
        
//        if BusinessModel.shared.usr.loggedIn.value {
//            performLogin()
//            return
//        }
        
        
        if BusinessModel.shared.usr.isValidCredentials == false {
            
            let hintAlert = alert(title: "", message: "Please complete all data fields to be able to access the Bug Wise application")
            self.present(hintAlert, animated: true, completion: nil)
            return
        }
        
        showDisclaimerAlert(agreeAction: { [weak self] in
            self?.performLogin()
        }, disagreeAction: nil)
    }
    
    private func performLogin() {
        showHud()
        BusinessModel.shared.performLogIn(onSuccess: {
            showHud(message:"Success", completion: {
            })
        }, onFail: { errorDesc in
            
            showHud(success: false, message: errorDesc ?? " Fail ", completion: {
            })
        })
    }
    
    private func bindButton(button: UIButton, array: [String] , actionSheetTitle: String?, block: @escaping BindBlock) {
        
        button
            .rx
            .tap
            .asObservable()
            .subscribe { [weak self] _ in
        
            var actionsArray = array.map({ str in
                UIAlertAction(title: str, style: .default) { actionButton in
                    button.setTitle(str, for: .normal)
                    block(str)
                }
            })
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionsArray.append(cancelButton)
            
            let actionSheet = alert(withTitle: actionSheetTitle ?? "", actions: actionsArray, style: .actionSheet)
            
            self?.present(actionSheet, animated: true, completion: nil)
            
            }.addDisposableTo(disposeBag)
    }
}
