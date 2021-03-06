//
//  ReminderViewController.swift
//  BugWise
//
//  Created by olbu on 9/26/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import UserNotifications

let messageText = "Medicines stay in your body for a certain amount of time. It is important to take your antibiotics at the same time every day according to the instruction from your doctor. Taking antibiotics irregularly allows bacteria to change and reproduce, contributing to the problem of antibiotic resistance."
let errorMessage = "Please enter antibiotic name to proceed"

let secInDay: Double = 86400

struct ScheduleHeight {
    static let expanded: CGFloat = 38.0
    static let colapsed: CGFloat = 0.0
}

struct TimesLabel {
    static let cornerRadius: CGFloat = 20.0
    static let height: CGFloat = 32.0
    static let width: CGFloat = 65.0
    static let spaceBetween: CGFloat = 10.0
}

let reminderNotificationTitle = "Medicine reminder"

class ReminderViewController: UIViewController {
    
    @IBOutlet weak var switchStatusOffLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var switchStatusOnLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scheduleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scheduleView: UIView!
    
    @IBOutlet weak var antibioticField: ProfileTextField!
    @IBOutlet weak var timeField: ProfileTextField!
    @IBOutlet weak var startDateField: ProfileTextField!
    @IBOutlet weak var endDateField: ProfileTextField!
    
    var antibioticEntity: SearchModuleItem? = nil
    private let disposeBag = DisposeBag()
    var layoutBlock : voidBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchControl.isOn = BusinessModel.shared.usr.reminderModel.isEnabled
        
        scheduleViewHeight.constant = ScheduleHeight.colapsed
        
        messageLabel.text = messageText
        antibioticField.textField.textColor = CommonAppearance.lighBlueColor
        antibioticField.textField.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        
        if BusinessModel.shared.usr.reminderModel.isEnabled {
            switchStatusOffLabel.textColor = UIColor(netHex: 0x8C8C8C)
        } else {
            switchStatusOnLabel.textColor = UIColor(netHex: 0x8C8C8C)
        }
        switchControl.tintColor = UIColor(netHex: 0xC8C7CC)
        
        timeField.textField.isUserInteractionEnabled = false
        startDateField.textField.isUserInteractionEnabled = false
        endDateField.textField.isUserInteractionEnabled = false
        
        layoutBlock = { [weak self] in
            self?.bindWithExistingData()
        }
        
        
        antibioticField.textField
            .rx
            .text
            .orEmpty
            .skip(1)
            .subscribe(onNext: { text in
                BusinessModel.shared.usr.reminderModel.antibioticName = text
            }).addDisposableTo(disposeBag)
        
        timeField
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe{ [weak self] _ in
                let datepicker = ReminderPickerViewController.controller(type: .time,
                                                                         selectedDate: BusinessModel.shared.usr.reminderModel.startTime,
                    timesPerDay: ReminderPickTimePerDay(rawValue: BusinessModel.shared.usr.reminderModel.timesPerDay ?? 1),
                    
                                                                         onPickSelect: { (pickedTime) in
                                                                            
                                                                            BusinessModel.shared.usr.reminderModel.timesPerDay = pickedTime.timePerDay?.rawValue
                                                                            BusinessModel.shared.usr.reminderModel.startTime = pickedTime.date
                                                                            
                                                                            self?.bindWithExistingData()
                        
                })
                
                self?.showDatePicker(datepicker)
            }
            .addDisposableTo(disposeBag)
        
        startDateField
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe{ [weak self] _ in
                
                var minDate = Date()
                
                var selectedDate = minDate
                
                if let startDate = BusinessModel.shared.usr.reminderModel.startDate {
                    selectedDate = startDate
                }
                
                minDate = selectedDate < minDate ? selectedDate : minDate
                
                let datepicker = ReminderPickerViewController.controller(type: .date,
                                                                         minDate: minDate,
                                                                         selectedDate: selectedDate,
                                                                         onPickSelect: { (pickedTime) in
                                                             BusinessModel.shared.usr.reminderModel.startDate = pickedTime.date
                                                                            self?.bindWithExistingData()
                })
                
                self?.showDatePicker(datepicker)
            }
            .addDisposableTo(disposeBag)
        
        endDateField
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe{ [weak self] _ in
                
                var minDate = Date(timeIntervalSinceNow: secInDay)
                
                var selectedDate = minDate
                
                if BusinessModel.shared.usr.reminderModel.endDate != nil {
                    if let endDate = BusinessModel.shared.usr.reminderModel.endDate {
                        selectedDate = endDate
                    }
                } else {
                    if let startDate = BusinessModel.shared.usr.reminderModel.startDate {
                        selectedDate = startDate.addingTimeInterval(secInDay)
                    }
                }
                
                minDate = selectedDate < minDate ? selectedDate : minDate
                
                let datepicker = ReminderPickerViewController.controller(type: .date,
                                                                         minDate: minDate,
                                                                         selectedDate: selectedDate,
                                                                         onPickSelect: { (pickedTime) in
                                                                            BusinessModel.shared.usr.reminderModel.endDate = pickedTime.date
                                                                            self?.bindWithExistingData()
                })
                
                self?.showDatePicker(datepicker)
            }
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutBlock?()
        layoutBlock = nil
    }
    
    private func showAlertForChangeAntibiotic(oldValue: String, newValue: String) {
        let message = "Currently medicine reminder is set up for \(oldValue). Would you like to change it to \(newValue)?"
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) { _ in
            
        }
        let changeAction = UIAlertAction(title: "CHANGE", style: .default) { _ in
            BusinessModel.shared.usr.reminderModel.antibioticName = newValue
            self.antibioticField.textField.text = newValue
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            self.setupNotificationSchedule()
        }
        
        let alertVC = alert(withTitle: reminderNotificationTitle, message: message, actions: [cancelAction, changeAction], style: .alert)
        present(alertVC, animated: true, completion: nil)
    }
    
    func bindWithExistingData() {
        
        if let antibioticID = antibioticEntity?.id, let detailedAntibiotic = EntitiesManager.shared.antibioticCached(id: antibioticID) {
            if (BusinessModel.shared.usr.reminderModel.isEnabled){
                showAlertForChangeAntibiotic(oldValue: BusinessModel.shared.usr.reminderModel.antibioticName ?? "", newValue: detailedAntibiotic.heading ?? "")
                antibioticField.textField.text = BusinessModel.shared.usr.reminderModel.antibioticName
            } else {
                antibioticField.textField.text = detailedAntibiotic.heading
                BusinessModel.shared.usr.reminderModel.antibioticName = detailedAntibiotic.heading
            }
            
        } else {
            antibioticField.textField.text = BusinessModel.shared.usr.reminderModel.antibioticName
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        
        if let startDate = BusinessModel.shared.usr.reminderModel.startDate {
            startDateField.textField.text = formatter.string(from: startDate)
        }
        
        if let endDate = BusinessModel.shared.usr.reminderModel.endDate {
            endDateField.textField.text = formatter.string(from: endDate)
        }
        
        formatter.dateFormat = "hh:mm a"
        
        if let startTime = BusinessModel.shared.usr.reminderModel.startTime {
            var dateStr = formatter.string(from: startTime)
            
            if let timesPerDay = BusinessModel.shared.usr.reminderModel.timesPerDay {
                dateStr.append(", \(timesPerDay) " + ((timesPerDay == 1) ? "time" : "times") + " a day" )
                
                updateTimesView()
            }
            
            timeField.textField.text = dateStr
        }
        
        enableControls(!BusinessModel.shared.usr.reminderModel.isEnabled)
    }
    
    @IBAction func switchButtonAction(_ sender: UIButton) {
        swithcUpdateStatus()
    }
    
    func updateTimesView() {
        
        guard let count = BusinessModel.shared.usr.reminderModel.timesPerDay,
            let startTime = BusinessModel.shared.usr.reminderModel.startTime else {
            return
        }
        
        if scheduleViewHeight.constant == ScheduleHeight.colapsed {
            scheduleViewHeight.constant = ScheduleHeight.expanded
        }
        
        scheduleView.subviews.forEach{ $0.removeFromSuperview() }
        
        let labelFullWidth = TimesLabel.width + TimesLabel.spaceBetween
        
        var xOrigin = (290 - CGFloat(count)*labelFullWidth + TimesLabel.spaceBetween)/2
        
        let yOrigin: CGFloat = 0
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "hh:mm a"
        
        let deltaSec = TimeInterval(secInDay/Double(count))
        
        var start = startTime
        
        for _ in 1...count {
            let label = UILabel(frame: CGRect(x: xOrigin, y: yOrigin, width: TimesLabel.width, height: TimesLabel.height))
            
            xOrigin += labelFullWidth
            
            label.backgroundColor = UIColor(netHex: 0xFF9A10)
            label.layer.cornerRadius = 15
            label.layer.masksToBounds = true
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = RegularFontWithSize(size: 10)
            label.text = dateformatter.string(from: start)
            
            start.addTimeInterval(deltaSec)
            
            scheduleView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.equalTo(label.frame.origin.x)
                make.size.equalTo(label.frame.size)
            }
        }
    }
    
    
    func swithcUpdateStatus() {
        
        if self.switchControl.isOn == false && (antibioticField.textField.text?.characters.count == 0 || BusinessModel.shared.usr.reminderModel.startDate == nil || BusinessModel.shared.usr.reminderModel.startTime == nil || BusinessModel.shared.usr.reminderModel.endDate == nil || BusinessModel.shared.usr.reminderModel.timesPerDay == nil) {
            let errorAlert = alert(title: "", message: errorMessage)
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        
        let setupSchedule = !self.switchControl.isOn
        switchControl.setOn(setupSchedule, animated: true)
        
        if setupSchedule {
            setupNotificationSchedule()
            switchStatusOffLabel.textColor = UIColor(netHex: 0x8C8C8C)
            switchStatusOnLabel.textColor = UIColor.black
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            switchStatusOffLabel.textColor = UIColor.black
            switchStatusOnLabel.textColor = UIColor(netHex: 0x8C8C8C)
        }
        
        enableControls(!setupSchedule)
        
        BusinessModel.shared.usr.reminderModel.isEnabled = setupSchedule
    }
    
    
    func enableControls(_ enable: Bool) {
        antibioticField.isUserInteractionEnabled = enable
        startDateField.isUserInteractionEnabled = enable
        endDateField.isUserInteractionEnabled = enable
        timeField.isUserInteractionEnabled = enable
    }
    
    func setupNotificationSchedule() {
        
        let reminderModel = BusinessModel.shared.usr.reminderModel
        
        guard let startDate = reminderModel.startDate,
              let endDate = reminderModel.endDate,
              let startTime = reminderModel.startTime,
              let timesPerDay = reminderModel.timesPerDay else {
            return
        }
        
        let currentDate = Date()
        
        if currentDate > endDate {
            return
        }
        
        let cal = Calendar.current
        
        let days = endDate.interval(ofComponent: .day, fromDate: startDate)
        
        if days < 0 {
            return
        }
        
        var dates = [Date?]()
        
        var i: Int = 0
        
        var currentStartDate = cal.date(bySettingHour: cal.component(.hour, from: startTime),
                                        minute: cal.component(.minute, from: startTime),
                                        second: cal.component(.second, from: startTime),
                                        of: startDate)
        let deltaSec = TimeInterval(secInDay/Double(timesPerDay))
        
        repeat {
            for _ in 1 ... timesPerDay {
                dates.append(currentStartDate)
                currentStartDate?.addTimeInterval(deltaSec)
                
            }
            
            currentStartDate?.addTimeInterval(deltaSec)
            
            i += 1
            
        }  while i < days

        scheduleNotif(dates: dates)
        
    }
    
    func scheduleNotif(dates: Array<Date?>) {
        
        for date in dates {
            
            guard let date = date else {
                continue
            }
            
            let notif = UNMutableNotificationContent()
            notif.title = reminderNotificationTitle
            let antibiotic = BusinessModel.shared.usr.reminderModel.antibioticName ?? ""
            notif.body =  "Time to take \(antibiotic)"
            notif.sound = UNNotificationSound.default()
            notif.badge = NSNumber(value: 1)
            
            var dateComponents = DateComponents()
            
            let calendar = Calendar.current
            
            dateComponents.year = calendar.component(.year, from: date)
            dateComponents.month = calendar.component(.month, from: date)
            dateComponents.day = calendar.component(.day, from: date)
            dateComponents.hour = calendar.component(.hour, from: date)
            dateComponents.minute = calendar.component(.minute, from: date)
            
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier:"\(dateComponents.year)+\(dateComponents.month)+\(dateComponents.day)+\(dateComponents.hour)+\(dateComponents.minute)", content: notif, trigger: dateTrigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                
                if error != nil {
                    print("scheduleNotif is failed")
                }
            })
        }
    }
    
    func showDatePicker(_ pickerController: ReminderPickerViewController) {

        view.endEditing(true)
        
        pickerController.view.frame = self.view.frame
        
        self.addChildViewController(pickerController)
        
        self.view.addSubview(pickerController.view)
        
        pickerController
            .view
            .snp
            .makeConstraints { (make) ->() in
                make.size.equalToSuperview()
                make.center.equalToSuperview()
        }
        
        pickerController.showAnimated()
    }
    
}

extension ReminderViewController {
    static func controller(antibiotic: SearchModuleItem? = nil) -> ReminderViewController {
        let controller = ReminderViewController.controllerFromStoryboard(.reminder)
        controller.antibioticEntity = antibiotic
        
        return controller
    }
}
