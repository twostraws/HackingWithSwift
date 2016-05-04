//
//  SubmitViewController.swift
//  Project33
//
//  Created by Hudzilla on 19/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import CloudKit
import UIKit

class SubmitViewController: UIViewController {
	var genre: String!
	var comments: String!

	var stackView: UIStackView!
	var status: UILabel!
	var spinner: UIActivityIndicatorView!

	override func loadView() {
		super.loadView()

		view.backgroundColor = UIColor.grayColor()

		stackView = UIStackView()
		stackView.spacing = 10
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = UIStackViewDistribution.FillEqually
		stackView.alignment = UIStackViewAlignment.Center
		stackView.axis = .Vertical
		view.addSubview(stackView)

		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["stackView": stackView]))
		view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant:0))

		status = UILabel()
		status.translatesAutoresizingMaskIntoConstraints = false
		status.text = "Submitting…"
		status.textColor = UIColor.whiteColor()
		status.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
		status.numberOfLines = 0
		status.textAlignment = .Center

		spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		spinner.hidesWhenStopped = true
		spinner.startAnimating()

		stackView.addArrangedSubview(status)
		stackView.addArrangedSubview(spinner)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "You're all set!"
		navigationItem.hidesBackButton = true
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		doSubmission()
	}

	func doSubmission() {
		let whistleRecord = CKRecord(recordType: "Whistles")
		whistleRecord["genre"] = genre
		whistleRecord["comments"] = comments

		let audioURL = RecordWhistleViewController.getWhistleURL()
		let whistleAsset = CKAsset(fileURL: audioURL)
		whistleRecord["audio"] = whistleAsset

		CKContainer.defaultContainer().publicCloudDatabase.saveRecord(whistleRecord) { [unowned self] (record, error) -> Void in
			dispatch_async(dispatch_get_main_queue()) {
				if error == nil {
					self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
					self.status.text = "Done!"
					self.spinner.stopAnimating()

					ViewController.dirty = true
				} else {
					self.status.text = "Error: \(error!.localizedDescription)"
					self.spinner.stopAnimating()
				}

				self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(self.doneTapped))
			}
		}
	}

	func doneTapped() {
		navigationController?.popToRootViewControllerAnimated(true)
	}
}
