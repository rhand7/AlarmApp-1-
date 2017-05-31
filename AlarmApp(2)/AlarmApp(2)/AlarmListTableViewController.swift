//
//  AlarmListTableViewController.swift
//  AlarmApp(2)
//
//  Created by handje on 5/30/17.
//  Copyright © 2017 Rob Hand. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    // MARK: - TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedController.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell
        
        let alarm = AlarmController.sharedController.alarms[indexPath.row]
        cell?.timeLabel.text = alarm.name
        cell?.timeLabel.text = alarm.fireTimeAsString
        cell?.alarmSwitch.isOn = alarm.enabled

        return cell ?? UITableViewCell()
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
        guard let alarm = cell.alarm else { return }
        AlarmController.sharedController.toggleEnabled(for: alarm)
        
        tableView.reloadData() 
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
