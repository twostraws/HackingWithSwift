//
//  ViewController.swift
//  Project39
//
//  Created by TwoStraws on 26/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	var playData = PlayData()

	override func viewDidLoad() {
		super.viewDidLoad()

		    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return playData.filteredWords.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let word = playData.filteredWords[indexPath.row]
		cell.textLabel!.text = word
		cell.detailTextLabel!.text = "\(playData.wordCounts.count(for: word))"
		
		return cell
	}

	@objc func searchTapped() {
		let ac = UIAlertController(title: "Filter…", message: nil, preferredStyle: .alert)
		ac.addTextField()

		ac.addAction(UIAlertAction(title: "Filter", style: .default) { [unowned self] _ in
			let userInput = ac.textFields?[0].text ?? "0"
			self.playData.applyUserFilter(userInput)
			self.tableView.reloadData()
		})

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		present(ac, animated: true)
	}
}

