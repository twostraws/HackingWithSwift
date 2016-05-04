//
//  ViewController.swift
//  Project19
//
//  Created by Hudzilla on 16/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var mapView: MKMapView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
		let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
		let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
		let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
		let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")

		mapView.addAnnotations([london, oslo, paris, rome, washington])
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		// 1
		let identifier = "Capital"

		// 2
		if annotation is Capital {
			// 3
			var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)

			if annotationView == nil {
				//4
				annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
				annotationView!.canShowCallout = true

				// 5
				let btn = UIButton(type: .DetailDisclosure)
				annotationView!.rightCalloutAccessoryView = btn
			} else {
				// 6
				annotationView!.annotation = annotation
			}

			return annotationView
		}

		// 7
		return nil
	}

	func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
		let capital = view.annotation as! Capital
		let placeName = capital.title
		let placeInfo = capital.info

		let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
		ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		presentViewController(ac, animated: true, completion: nil)
	}
}

