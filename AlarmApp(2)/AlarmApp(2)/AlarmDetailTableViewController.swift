//
//  AlarmDetailTableViewController.swift
//  AlarmApp(2)
//
//  Created by handje on 5/30/17.
//  Copyright © 2017 Rob Hand. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews() 
    }
    
    // MARK: - Properties 
    var alarm: Alarm? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    // MARK: - IB Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmName: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    
    // MARK: - IB Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = alarmName.text,
            let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return }
        let timeIntervalSinceMidnight = datePicker.date.timeIntervalSince(thisMorningAtMidnight)
        if let alarm = alarm {
            AlarmController.sharedController.updateAlarm(alarm: alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: name)
            cancelUserNotifications(for: alarm)
            scheduleUserNotification(for: alarm) 
        } else {
            let alarm = AlarmController.sharedController.addAlarm(fireTimeFromMidnight: timeIntervalSinceMidnight, name: name)
            self.alarm = alarm
            scheduleUserNotification(for: alarm)
        }
        let _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
        AlarmController.sharedController.toggleEnabled(for: alarm)
        if alarm.enabled {
            scheduleUserNotification(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        updateViews() 
    }
    
    // MARK: - private
    private func updateViews() {
        guard let alarm = alarm,
        let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight,
        isViewLoaded else {
            buttonLabel.isHidden = true
            return
        }
        
        datePicker.setDate(Date(timeInterval: alarm.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: false)
        alarmName.text = alarm.name
        
        buttonLabel.isHidden = false
        if alarm.enabled {
            buttonLabel.setTitle("Disable", for: UIControlState())
            buttonLabel.setTitleColor(.white, for: UIControlState())
            buttonLabel.backgroundColor = .red
        } else {
            buttonLabel.setTitle("Enable", for: UIControlState())
            buttonLabel.setTitleColor(.blue, for: UIControlState())
            buttonLabel.backgroundColor = .gray
        }
        self.title = alarm.name
    }
}
