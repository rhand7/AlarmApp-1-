//
//  AlarmController.swift
//  AlarmApp(2)
//
//  Created by handje on 5/30/17.
//  Copyright © 2017 Rob Hand. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController {
    
    static var sharedController = AlarmController()
    
    var alarms: [Alarm] = []
    
    init() {
        loadToPersistentStorage() 
    }
    
    // MARK: - CRUD
    
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> Alarm {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
        saveToPersistentStorage()
        return alarm
    }
    
    func updateAlarm(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        saveToPersistentStorage()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let alarmIndex = alarms.index(of: alarm) else { return }
        alarms.remove(at: alarmIndex)
        saveToPersistentStorage()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        saveToPersistentStorage() 
    }
    
    // MARK: - persistentAlarmsFilePath
    
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
    
    // MARK: - saveToPersistentStorage() / loadToPersistentStorage
    
    private func saveToPersistentStorage() {
        guard let filepath = type(of: self).persistentAlarmsFilePath else { return }
        NSKeyedArchiver.archiveRootObject(self.alarms, toFile: filepath)
    }
    
    private func loadToPersistentStorage() {
        guard let filepath = type(of: self).persistentAlarmsFilePath else { return }
        guard let alarms = NSKeyedUnarchiver.unarchiveObject(withFile: filepath) as? [Alarm] else { return }
        self.alarms = alarms
    }
}

protocol AlarmScheduler {
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotification(for alarm: Alarm) {
        let notifiactionContent = UNMutableNotificationContent()
        notifiactionContent.title = "Time's up!"
        notifiactionContent.body = "Your alarm \(alarm.name) is done"
        notifiactionContent.sound = UNNotificationSound.default()
        
        guard let fireDate = alarm.fireDate else { return }
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notifiactionContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request, \(error.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid]) 
    }
}























