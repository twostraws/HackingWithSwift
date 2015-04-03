//
//  ViewController.swift
//  Project18
//
//  Created by Hudzilla on 23/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import iAd
import UIKit

class ViewController: UIViewController, ADBannerViewDelegate {
	var bannerView: ADBannerView!

	override func viewDidLoad() {
		super.viewDidLoad()

		bannerView = ADBannerView(adType: .Banner)
		bannerView.setTranslatesAutoresizingMaskIntoConstraints(false)
		bannerView.delegate = self
		bannerView.hidden = true
		view.addSubview(bannerView)

		let viewsDictionary = ["bannerView": bannerView]
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: .allZeros, metrics: nil, views: viewsDictionary))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: .allZeros, metrics: nil, views: viewsDictionary))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func bannerViewDidLoadAd(banner: ADBannerView!) {
		bannerView.hidden = false
	}

	func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
		bannerView.hidden = true
	}
}

