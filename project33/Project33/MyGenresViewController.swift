//
//  MyGenresViewController.swift
//  Project33
//
//  Created by Hudzilla on 19/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import CloudKit
import UIKit

class MyGenresViewController: UITableViewController {
	var myGenres: [String]!

	override func viewDidLoad() {
		super.viewDidLoad()

		let defaults = NSUserDefaults.standardUserDefaults()
		if let savedGenres = defaults.objectForKey("myGenres") as? [String] {
			myGenres = savedGenres
		} else {
			myGenres = [String]()
		}

		title = "Notify me about…"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveTapped))
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

    // MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return SelectGenreViewController.genres.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

		let genre = SelectGenreViewController.genres[indexPath.row]
		cell.textLabel?.text = genre

		if myGenres.contains(genre) {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}

		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let cell = tableView.cellForRowAtIndexPath(indexPath) {
			let selectedGenre = SelectGenreViewController.genres[indexPath.row]

			if cell.accessoryType == .None {
				cell.accessoryType = .Checkmark
				myGenres.append(selectedGenre)
			} else {
				cell.accessoryType = .None

				if let index = myGenres.indexOf(selectedGenre) {
					myGenres.removeAtIndex(index)
				}
			}
		}

		tableView.deselectRowAtIndexPath(indexPath, animated: false)
	}

	func saveTapped() {
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setObject(myGenres, forKey: "myGenres")

		let database = CKContainer.defaultContainer().publicCloudDatabase

		database.fetchAllSubscriptionsWithCompletionHandler() { [unowned self] (subscriptions, error) -> Void in
			if error == nil {
				if let subscriptions = subscriptions {
					for subscription in subscriptions {
						database.deleteSubscriptionWithID(subscription.subscriptionID, completionHandler: { (str, error) -> Void in
							if error != nil {
								// do your error handling here!
								print(error!.localizedDescription)
							}
						})
					}

					for genre in self.myGenres {
						let predicate = NSPredicate(format:"genre = %@", genre)
						let subscription = CKSubscription(recordType: "Whistles", predicate: predicate, options: .FiresOnRecordCreation)

						let notification = CKNotificationInfo()
						notification.alertBody = "There's a new whistle in the \(genre) genre."
						notification.soundName = UILocalNotificationDefaultSoundName

						subscription.notificationInfo = notification

						database.saveSubscription(subscription) { (result, error) -> Void in
							if error != nil {
								print(error!.localizedDescription)
							}
						}
					}
				}
			} else {
				// do your error handling here!
				print(error!.localizedDescription)
			}
		}
	}
}
