//
//  MasterViewController.swift
//  Project1
//
//  Created by Hudzilla on 19/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
	var objects = [String]()

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let fm = NSFileManager.defaultManager()
		let path = NSBundle.mainBundle().resourcePath!
		let items = fm.contentsOfDirectoryAtPath(path, error: nil)

		for item in items as [String] {
			if item.hasPrefix("nssl") {
				objects.append(item)
			}
		}
	}

	override func viewWillAppear(animated: Bool) {
		tableView.selectRowAtIndexPath(nil, animated: true, scrollPosition: .None)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow() {
				let detailViewController = segue.destinationViewController as DetailViewController
				detailViewController.detailItem = objects[indexPath.row]
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

		cell.textLabel!.text = objects[indexPath.row]
		return cell
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 44
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
}

