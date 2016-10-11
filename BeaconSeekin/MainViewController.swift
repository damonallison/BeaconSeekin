//
//  ViewController.swift
//  BeaconSeekin
//
//  Created by Damon Allison on 10/7/16.
//  Copyright © 2016 Recursive Awesome. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UITableViewController, RegionMonitorDelegate {
    
    @IBOutlet weak var button : UIBarButtonItem!
    
    private var logItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        RegionMonitor.sharedInstance.delegate = self
        self.refreshButton()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = logItems[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func addLogItem(str: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
     
        let msg = "\(dateFormatter.string(from: Date())) : \(str)"
        logItems.insert(msg, at: 0)
        
        // The UITableViewCell is a
        NSLog("Logging \(msg)")
        self.tableView.reloadData()
    }

    func refreshButton() {
        if (RegionMonitor.sharedInstance.isMonitoring()) {
            button.title = "Stop"
        }
        else {
            button.title = "Start"
        }
    }
    
    @IBAction func toggleRunning(sender : UIBarButtonItem) {
     
        if (!CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)) {
            self.addLogItem(str: "Beacon monitoring not available!")
            return
        }
        if (RegionMonitor.sharedInstance.isMonitoring()) {
            RegionMonitor.sharedInstance.stop()
        }
        else {
            RegionMonitor.sharedInstance.start()
        }
    }
 
    
    // MARK: RegionMonitorDelegate
    
    func monitoringStarted(region: CLBeaconRegion) {
        self.addLogItem(str: "Monitoring started")
        NSLog("Monitoring started for \(region)")
        self.refreshButton()
    }
    
    func monitoringStopped(region: CLBeaconRegion) {
        self.addLogItem(str: "Monitoring stopped")
        NSLog("Monitoring stopped for \(region)")
        self.refreshButton()
    }
    
    func didEnterRegion(region: CLBeaconRegion) {
        self.addLogItem(str: "Found beacon")
        NSLog("Found beacon\(region)")
        sendLocalNotification(str: "Found beacon")
    }
    
    func didExitRegion(region: CLBeaconRegion) {
        self.addLogItem(str: "Lost beacon")
        NSLog("Lost beacon\(region)")
        sendLocalNotification(str: "Lost beacon")
    }
    
    func sendLocalNotification(str: String) {
        if UIApplication.shared.applicationState != UIApplicationState.active {
            let notification: UILocalNotification = UILocalNotification()
            notification.alertBody = str
            notification.alertAction = str
            let myDate: Date = Date()
            notification.fireDate = myDate.addingTimeInterval(Double(1))
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
}

