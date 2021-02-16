//
//  ViewController.swift
//  Project22
//
//  Created by TwoStraws on 19/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
	@IBOutlet var distanceReading: UILabel!

	var locationManager: CLLocationManager!

	override func viewDidLoad() {
		super.viewDidLoad()

		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()

		view.backgroundColor = UIColor.gray
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				}
			}
		}
	}

	func startScanning() {
		let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        
        let beaconIDConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: CLBeaconMajorValue(123), minor: CLBeaconMinorValue(456))
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconIDConstraint, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconIDConstraint)
	}

	func update(distance: CLProximity) {
		UIView.animate(withDuration: 0.8) { [unowned self] in
			switch distance {
            
			case .far:
				self.view.backgroundColor = UIColor.blue
				self.distanceReading.text = "FAR"

			case .near:
				self.view.backgroundColor = UIColor.orange
				self.distanceReading.text = "NEAR"

			case .immediate:
				self.view.backgroundColor = UIColor.red
				self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
			}
		}
	}

	func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
		if beacons.count > 0 {
			let beacon = beacons[0]
			update(distance: beacon.proximity)
		} else {
			update(distance: .unknown)
		}
	}
}

