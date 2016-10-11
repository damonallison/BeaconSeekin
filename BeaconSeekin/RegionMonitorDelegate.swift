//
//  RegionMonitorDelegate.swift
//  BeaconSeekin
//
//  Created by Damon Allison on 10/11/16.
//  Copyright © 2016 Recursive Awesome. All rights reserved.
//

import Foundation
import CoreLocation

protocol RegionMonitorDelegate : class {
    
    func monitoringStarted(region: CLBeaconRegion)
    func monitoringStopped(region: CLBeaconRegion)
    
    func didEnterRegion(region: CLBeaconRegion)
    func didExitRegion(region: CLBeaconRegion)
    
}
