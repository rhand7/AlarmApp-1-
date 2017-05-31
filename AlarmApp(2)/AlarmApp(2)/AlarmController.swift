//
//  AlarmController.swift
//  AlarmApp(2)
//
//  Created by handje on 5/30/17.
//  Copyright © 2017 Rob Hand. All rights reserved.
//

import Foundation

class AlarmController {
    
    static var sharedController = AlarmController()
    
    var alarms: [Alarm] = []
    
//    var mockAlarms: [Alarm] {
//        let mock1 = Alarm(fireTimeFromMidnight: 7, name: "Morning", enabled: true, uuid: "10294")
//        let mock2 = Alarm(fireTimeFromMidnight: 7, name: "Morning")
//    return self.mockAlarms
//    }
    
    init() {
        
    }
    
    // MARK: - CRUD
    
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> Alarm {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
        //saveToPersistentStorage()
        return alarm
    }
    
    func updateAlarm(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let alarmIndex = alarms.index(of: alarm) else { return }
        alarms.remove(at: alarmIndex)
        //saveToPersistentStorage()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        //saveToPersistentStorage() 
    }
}
