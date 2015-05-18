//
//  ViewController.swift
//  Project19
//
//  Created by Hudzilla on 23/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
	@IBOutlet weak var mapView: MKMapView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
		let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
		let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
		let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
		let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")

//		mapView.addAnnotation(london)
//		mapView.addAnnotation(oslo)
//		mapView.addAnnotation(paris)
//		mapView.addAnnotation(rome)
//		mapView.addAnnotation(washington)

		mapView.addAnnotations([london, oslo, paris, rome, washington])
	}

	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		let identifier = "Capital"

		if annotation.isKindOfClass(Capital.self) {
			var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)

			if annotationView == nil {
				annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
				annotationView.enabled = true
				annotationView.canShowCallout = true

				let btn = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
				annotationView.rightCalloutAccessoryView = btn
			} else {
				annotationView.annotation = annotation
			}

			return annotationView
		}

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

