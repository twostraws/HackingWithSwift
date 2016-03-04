//
//  ViewController.swift
//  Project39
//
//  Created by Hudzilla on 04/03/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	var playData = PlayData()

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(searchTapped))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return playData.filteredWords.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

		let word = playData.filteredWords[indexPath.row]
		cell.textLabel!.text = word
		cell.detailTextLabel!.text = "\(playData.wordCounts.countForObject(word))"
		return cell
	}

	func searchTapped() {
		let ac = UIAlertController(title: "Filter…", message: nil, preferredStyle: .Alert)
		ac.addTextFieldWithConfigurationHandler(nil)

		ac.addAction(UIAlertAction(title: "Filter", style: .Default, handler: { [unowned self] _ in
			let userInput = ac.textFields?[0].text ?? "0"
			self.playData.applyUserFilter(userInput)
			self.tableView.reloadData()
			}))

		ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

		presentViewController(ac, animated: true, completion: nil)
	}
}

