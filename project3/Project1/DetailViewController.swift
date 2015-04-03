//
//  DetailViewController.swift
//  Project1
//
//  Created by Hudzilla on 19/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import Social
import UIKit

class DetailViewController: UIViewController {
	@IBOutlet weak var detailImageView: UIImageView!

	var detailItem: String? {
		didSet {
		    // Update the view.
		    self.configureView()
		}
	}

	func configureView() {
		// Update the user interface for the detail item.
		if let detail = self.detailItem {
		    if let imageView = self.detailImageView {
		        imageView.image = UIImage(named: detail)
		    }
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		configureView()

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		self.navigationController?.hidesBarsOnTap = true
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		self.navigationController?.hidesBarsOnTap = false
	}

	func shareTapped() {
//		let vc = UIActivityViewController(activityItems: [detailImageView.image!], applicationActivities: [])
//		presentViewController(vc, animated: true, completion: nil)

		// Alternate, Social way of posting to Facebook
		let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
		vc.setInitialText("Look at this great picture!")
		vc.addImage(detailImageView.image!)
		vc.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
		presentViewController(vc, animated: true, completion: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

