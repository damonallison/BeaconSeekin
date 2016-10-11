//
//  ViewController.swift
//  BeaconSeekin
//
//  Created by Damon Allison on 10/7/16.
//  Copyright © 2016 Recursive Awesome. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UITableViewController, CLLocationManagerDelegate {

    // Constants. 
    
    // Beacon identifier is an internal identifier string only. The beacons are not
    // configured with this identiifer.
    private let beaconIdentifier = "com.recursiveawesome.BeaconSeekin"
    private let uuid = UUID(uuidString: "ac00560e-9c98-4e7d-8da4-849e493269f7")!
    private let major = 99
    private let minor = 99

    private var locationManager : CLLocationManager!
    private var region : CLBeaconRegion!

    @IBOutlet weak var button : UIBarButtonItem!
    
    private var logItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        region = CLBeaconRegion(proximityUUID: self.uuid,
                                major: CLBeaconMajorValue(self.major),
                                minor: CLBeaconMinorValue(self.minor),
                                identifier: self.beaconIdentifier);
        region.notifyOnEntry = true
        region.notifyOnExit = true
        region.notifyEntryStateOnDisplay = true

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        
        // Check authorization status
        let status = CLLocationManager.authorizationStatus()
        switch(status) {
        case .denied, .restricted:
            self.addLogItem(str: "App not allowed to use location services.")
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        default:
            self.addLogItem(str: "Location services are enabled.")
            
        }
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
    
    @IBAction func toggleRunning(sender : UIBarButtonItem) {
     
        if (!CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)) {
            self.addLogItem(str: "Beacon monitoring not available!")
            return
        }
        
        if (self.isMonitoring()) {
            self.locationManager.stopMonitoring(for: region)
            self.addLogItem(str: "Stopped scanning")
            button.title = "Start"
        }
        else {
            self.locationManager.startMonitoring(for: region)
            self.addLogItem(str: "Started scanning")
            button.title = "Stop"
        }
    }
    
    private func isMonitoring() -> Bool {
        return self.locationManager.monitoredRegions.contains(self.region);
    }

    
    // MARK: CLLocationManagerDelegate
    
    /*
     *  locationManager:didRangeBeacons:inRegion:
     *
     *  Discussion:
     *    Invoked when a new set of beacons are available in the specified region.
     *    beacons is an array of CLBeacon objects.
     *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
     *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
     *    by the device.
     */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.addLogItem(str: "didRangeBeacons \(beacons) \(region)")
    }
    
    
    /*
     *  locationManager:rangingBeaconsDidFailForRegion:withError:
     *
     *  Discussion:
     *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
     */
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        self.addLogItem(str: "rangingBeaconsDidFailFor \(region) withError \(error)")
    }
    
    
    /*
     *  locationManager:didEnterRegion:
     *
     *  Discussion:
     *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
     *    CLLocationManager instance with a non-nil delegate that implements this method.
     */
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.addLogItem(str: "didEnterRegion \(region)")
    }
    
    
    /*
     *  locationManager:didExitRegion:
     *
     *  Discussion:
     *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
     *    CLLocationManager instance with a non-nil delegate that implements this method.
     */
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.addLogItem(str: "didExitRegion \(region)")
    }
    
    
    /*
     *  locationManager:didFailWithError:
     *
     *  Discussion:
     *    Invoked when an error has occurred. Error types are defined in "CLError.h".
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.addLogItem(str: "didFailWithError \(error)")
    }
    
    /*
     *  locationManager:monitoringDidFailForRegion:withError:
     *
     *  Discussion:
     *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
     */
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        self.addLogItem(str: "monitoringDidFailFor \(region) withError \(error)")
    }
    
}

