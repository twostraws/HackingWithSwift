//
//  SelectionViewController.swift
//  Project30
//
//  Created by Hudzilla on 26/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//
//  The images used in this app are blurry copies of images used in my
//  Mythology app. As keen as I am to help you learn, I have my limits :)

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
	var dirty = false

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Select-a-Greek"

		tableView.rowHeight = 250
		tableView.separatorStyle = .None

		// load all the JPEGs into our array
		let fm = NSFileManager.defaultManager()

		if let tempItems = try? fm.contentsOfDirectoryAtPath(NSBundle.mainBundle().resourcePath!) {
			for item in tempItems {
				if item.hasSuffix(".jpg") {
					items.append(item)
				}
			}
		}
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")

		// find the image for this cell, and load its thumbnail
		let currentImage = items[indexPath.row]
		let imageRootName = currentImage.stringByReplacingOccurrencesOfString(".jpg", withString: "")

		let path = NSBundle.mainBundle().pathForResource(imageRootName, ofType: "png")!
		cell.imageView!.image = UIImage(contentsOfFile: path)

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView!.layer.shadowColor = UIColor.blackColor().CGColor
		cell.imageView!.layer.shadowOpacity = 1
		cell.imageView!.layer.shadowRadius = 10

		// each image stores how often it's been tapped
		let defaults = NSUserDefaults.standardUserDefaults()
		cell.textLabel!.text = "\(defaults.integerForKey(currentImage))"

		return cell
    }

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		// add to our view controller cache and show
		viewControllers.append(vc)
		navigationController!.pushViewController(vc, animated: true)
	}
}
