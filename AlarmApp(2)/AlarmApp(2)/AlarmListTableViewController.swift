//
//  AlarmListTableViewController.swift
//  AlarmApp(2)
//
//  Created by handje on 5/30/17.
//  Copyright © 2017 Rob Hand. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedController.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell ?? SwitchTableViewCell()
        
        cell.alarm = AlarmController.sharedController.alarms[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ac = AlarmController.sharedController
            let alarm = ac.alarms[indexPath.row]
            ac.deleteAlarm(alarm: alarm)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - SwitchTableViewCellDelegate
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.sharedController.alarms[indexPath.row]
        AlarmController.sharedController.toggleEnabled(for: alarm)
        
        if alarm.enabled {
            scheduleUserNotification(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetail" {
            guard let detailVC = segue.destination as? AlarmDetailTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.alarm = AlarmController.sharedController.alarms[indexPath.row]
        } 
    }
}
