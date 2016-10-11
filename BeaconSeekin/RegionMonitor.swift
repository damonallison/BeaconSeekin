//
//  RegionMonitor.swift
//  BeaconSeekin
//
//  Created by Damon Allison on 10/11/16.
//  Copyright © 2016 Recursive Awesome. All rights reserved.
//

import Foundation
import CoreLocation

class RegionMonitor : NSObject, CLLocationManagerDelegate {

    // Constants.
    
    // Beacon identifier is an internal identifier string only. The beacons are not
    // configured with this identiifer.
    private let beaconIdentifier = "com.recursiveawesome.BeaconSeekin"
    let uuid = UUID(uuidString: "ac00560e-9c98-4e7d-8da4-849e493269f7")!
    let major = 99
    let minor = 99
    
    private var region: CLBeaconRegion
    private var locationManager: CLLocationManager
    
    weak var delegate: RegionMonitorDelegate?

    static let sharedInstance = RegionMonitor()
    
    private override init() {
        
        self.region = CLBeaconRegion(proximityUUID: self.uuid,
                                major: CLBeaconMajorValue(self.major),
                                minor: CLBeaconMinorValue(self.minor),
                                identifier: self.beaconIdentifier);
        region.notifyOnEntry = true
        region.notifyOnExit = true
        region.notifyEntryStateOnDisplay = true
        
        self.locationManager = CLLocationManager()

        super.init()
        
        self.locationManager.delegate = self;
        
        // Check authorization status
        let status = CLLocationManager.authorizationStatus()
        switch(status) {
        case .denied, .restricted:
            NSLog("App not allowed to use location services.")
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        default:
            NSLog("Location services are enabled")
        }
    }
    
    func isMonitoring() -> Bool {
        return self.locationManager.monitoredRegions.contains(self.region);
    }
    
    func start() {
        if (!self.isMonitoring()) {
            self.locationManager.startMonitoring(for: region)
            self.delegate?.monitoringStarted(region: region)
        }
    }
    
    func stop() {
        if (self.isMonitoring()) {
            self.locationManager.stopMonitoring(for: region)
            self.delegate?.monitoringStopped(region: region)
        }
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
        NSLog("didRangeBeacons \(beacons) \(region)")
    }
    
    
    /*
     *  locationManager:rangingBeaconsDidFailForRegion:withError:
     *
     *  Discussion:
     *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
     */
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        NSLog("rangingBeaconsDidFailFor \(region) withError \(error)")
    }
    
    
    /*
     *  locationManager:didEnterRegion:
     *
     *  Discussion:
     *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
     *    CLLocationManager instance with a non-nil delegate that implements this method.
     */
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.delegate?.didEnterRegion(region: region as! CLBeaconRegion)
    }
    
    /*
     *  locationManager:didExitRegion:
     *
     *  Discussion:
     *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
     *    CLLocationManager instance with a non-nil delegate that implements this method.
     */
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.delegate?.didExitRegion(region: region as! CLBeaconRegion)
    }
    
    
    /*
     *  locationManager:didFailWithError:
     *
     *  Discussion:
     *    Invoked when an error has occurred. Error types are defined in "CLError.h".
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("didFailWithError \(error)")
    }
    
    /*
     *  locationManager:monitoringDidFailForRegion:withError:
     *
     *  Discussion:
     *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
     */
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        NSLog("monitoringDidFailFor \(region) withError \(error)")
    }

    
}
