//
//  ViewController.swift
//  Project38
//
//  Created by TwoStraws on 25/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	var container: NSPersistentContainer!
	var fetchedResultsController: NSFetchedResultsController<Commit>!
	var commitPredicate: NSPredicate?

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))

		container = NSPersistentContainer(name: "Project38")

		container.loadPersistentStores { storeDescription, error in
			self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

			if let error = error {
				print("Unresolved error \(error)")
			}
		}

		performSelector(inBackground: #selector(fetchCommits), with: nil)
		loadSavedData()
	}

	func saveContext() {
		if container.viewContext.hasChanges {
			do {
				try container.viewContext.save()
			} catch {
				print("An error occurred while saving: \(error)")
			}
		}
	}

	@objc func fetchCommits() {
		let newestCommitDate = getNewestCommitDate()

		if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100&since=\(newestCommitDate)")!) {
			let jsonCommits = JSON(parseJSON: data)
			let jsonCommitArray = jsonCommits.arrayValue

			print("Received \(jsonCommitArray.count) new commits.")

			DispatchQueue.main.async { [unowned self] in
				for jsonCommit in jsonCommitArray {
					// the following three lines are new
					let commit = Commit(context: self.container.viewContext)
					self.configure(commit: commit, usingJSON: jsonCommit)
				}

				self.saveContext()
				self.loadSavedData()
			}
		}
	}

	func getNewestCommitDate() -> String {
		let formatter = ISO8601DateFormatter()

		let newest = Commit.createFetchRequest()
		let sort = NSSortDescriptor(key: "date", ascending: false)
		newest.sortDescriptors = [sort]
		newest.fetchLimit = 1

		if let commits = try? container.viewContext.fetch(newest) {
			if commits.count > 0 {
				return formatter.string(from: commits[0].date.addingTimeInterval(1))
			}
		}

		return formatter.string(from: Date(timeIntervalSince1970: 0))
	}

	func configure(commit: Commit, usingJSON json: JSON) {
		commit.sha = json["sha"].stringValue
		commit.message = json["commit"]["message"].stringValue
		commit.url = json["html_url"].stringValue

		let formatter = ISO8601DateFormatter()
		commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()

		var commitAuthor: Author!

		// see if this author exists already
		let authorRequest = Author.createFetchRequest()
		authorRequest.predicate = NSPredicate(format: "name == %@", json["commit"]["committer"]["name"].stringValue)

		if let authors = try? container.viewContext.fetch(authorRequest) {
			if authors.count > 0 {
				// we have this author already
				commitAuthor = authors[0]
			}
		}

		if commitAuthor == nil {
			// we didn't find a saved author - create a new one!
			let author = Author(context: container.viewContext)
			author.name = json["commit"]["committer"]["name"].stringValue
			author.email = json["commit"]["committer"]["email"].stringValue
			commitAuthor = author
		}

		// use the author, either saved or new
		commit.author = commitAuthor
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fetchedResultsController.sections![section].name
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)

		let commit = fetchedResultsController.object(at: indexPath)
		cell.textLabel!.text = commit.message
		cell.detailTextLabel!.text = "By \(commit.author.name) on \(commit.date.description)"

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			vc.detailItem = fetchedResultsController.object(at: indexPath)
			navigationController?.pushViewController(vc, animated: true)
		}
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let commit = fetchedResultsController.object(at: indexPath)
			container.viewContext.delete(commit)
			saveContext()
		}
	}

	func loadSavedData() {
		if fetchedResultsController == nil {
			let request = Commit.createFetchRequest()
			let sort = NSSortDescriptor(key: "author.name", ascending: true)
			request.sortDescriptors = [sort]
			request.fetchBatchSize = 20

			fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: "author.name", cacheName: nil)
			fetchedResultsController.delegate = self
		}

		fetchedResultsController.fetchRequest.predicate = commitPredicate

		do {
			try fetchedResultsController.performFetch()
			tableView.reloadData()
		} catch {
			print("Fetch failed")
		}
	}

	@objc func changeFilter() {
		let ac = UIAlertController(title: "Filter commits…", message: nil, preferredStyle: .actionSheet)

		// 1
		ac.addAction(UIAlertAction(title: "Show only fixes", style: .default) { [unowned self] _ in
			self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
			self.loadSavedData()
		})

		// 2
		ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default) { [unowned self] _ in
			self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
			self.loadSavedData()
		})

		// 3
		ac.addAction(UIAlertAction(title: "Show only recent", style: .default) { [unowned self] _ in
			let twelveHoursAgo = Date().addingTimeInterval(-43200)
			self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
			self.loadSavedData()
		})

		// 4
		ac.addAction(UIAlertAction(title: "Show only Durian commits", style: .default) { [unowned self] _ in
			self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
			self.loadSavedData()
		})

		// 5
		ac.addAction(UIAlertAction(title: "Show all commits", style: .default) { [unowned self] _ in
			self.commitPredicate = nil
			self.loadSavedData()
		})

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .automatic)

		default:
			break
		}
	}
}

