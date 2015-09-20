//
//  ViewController.swift
//  Project22
//
//  Created by Hudzilla on 16/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
	@IBOutlet weak var distanceReading: UILabel!

	var locationManager: CLLocationManager!

	override func viewDidLoad() {
		super.viewDidLoad()

		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()

		view.backgroundColor = UIColor.grayColor()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedAlways {
			if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				}
			}
		}
	}

	func startScanning() {
		let uuid = NSUUID(UUIDString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
		let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

		locationManager.startMonitoringForRegion(beaconRegion)
		locationManager.startRangingBeaconsInRegion(beaconRegion)
	}

	func updateDistance(distance: CLProximity) {
		UIView.animateWithDuration(0.8) { [unowned self] in
			switch distance {
			case .Unknown:
				self.view.backgroundColor = UIColor.grayColor()
				self.distanceReading.text = "UNKNOWN"

			case .Far:
				self.view.backgroundColor = UIColor.blueColor()
				self.distanceReading.text = "FAR"

			case .Near:
				self.view.backgroundColor = UIColor.orangeColor()
				self.distanceReading.text = "NEAR"

			case .Immediate:
				self.view.backgroundColor = UIColor.redColor()
				self.distanceReading.text = "RIGHT HERE"
			}
		}
	}

	func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
		if beacons.count > 0 {
			let beacon = beacons[0]
			updateDistance(beacon.proximity)
		} else {
			updateDistance(.Unknown)
		}
	}
}

