//
//  ViewController.swift
//  Project33
//
//  Created by TwoStraws on 24/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import CloudKit
import UIKit

class ViewController: UITableViewController {
	var whistles = [Whistle]()
    static var isDirty = true
	
	override func viewDidLoad() {
		super.viewDidLoad()

		title = "What's that Whistle?"

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Genres", style: .plain, target: self, action: #selector(selectGenre))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	@objc func addWhistle() {
		let vc = RecordWhistleViewController()
		navigationController?.pushViewController(vc, animated: true)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}

		if ViewController.isDirty {
			loadWhistles()
		}
	}

	func loadWhistles() {
		let pred = NSPredicate(value: true)
		let sort = NSSortDescriptor(key: "creationDate", ascending: false)
		let query = CKQuery(recordType: "Whistles", predicate: pred)
		query.sortDescriptors = [sort]

		let operation = CKQueryOperation(query: query)
		operation.desiredKeys = ["genre", "comments"]
		operation.resultsLimit = 50

		var newWhistles = [Whistle]()

		operation.recordFetchedBlock = { record in
			let whistle = Whistle()
			whistle.recordID = record.recordID
			whistle.genre = record["genre"]
			whistle.comments = record["comments"]
			newWhistles.append(whistle)
		}

		operation.queryCompletionBlock = { [unowned self] (cursor, error) in
			DispatchQueue.main.async {
				if error == nil {
					ViewController.isDirty = false
					self.whistles = newWhistles
					self.tableView.reloadData()
				} else {
					let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of whistles; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					self.present(ac, animated: true)
				}
			}
		}

		CKContainer.default().publicCloudDatabase.add(operation)
	}

	func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
		let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]

		let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)

		if subtitle.count > 0 {
			let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
			titleString.append(subtitleString)
		}

		return titleString
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.attributedText =  makeAttributedString(title: whistles[indexPath.row].genre, subtitle: whistles[indexPath.row].comments)
		cell.textLabel?.numberOfLines = 0
		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.whistles.count
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ResultsViewController()
		vc.whistle = whistles[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}

	@objc func selectGenre() {
		let vc = MyGenresViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
}

