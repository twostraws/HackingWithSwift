//
//  MasterViewController.swift
//  Project5
//
//  Created by Hudzilla on 19/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
	var allWords = [String]()
	var objects = [String]()


	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "startGame")
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")

		if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
			if let startWords = NSString(contentsOfFile: startWordsPath, usedEncoding: nil, error: nil) {
				allWords = startWords.componentsSeparatedByString("\n") as! [String]
			}
		} else {
			allWords = ["silkworm"]
		}

		startGame()
	}

	func promptForAnswer() {
		let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
		ac.addTextFieldWithConfigurationHandler(nil)

		let submitAction = UIAlertAction(title: "Submit", style: .Default) { [unowned self, ac] (action: UIAlertAction!) in
			let answer = ac.textFields![0] as! UITextField
			self.submitAnswer(answer.text)
		}

		ac.addAction(submitAction)

		presentViewController(ac, animated: true, completion: nil)
	}

	func submitAnswer(answer: String) {
		let lowerAnswer = answer.lowercaseString

		if wordIsPossible(lowerAnswer) {
			if wordIsOriginal(lowerAnswer) {
				if wordIsReal(lowerAnswer) {
					objects.insert(answer, atIndex: 0)

					let indexPath = NSIndexPath(forRow: 0, inSection: 0)
					tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
				} else {
					let ac = UIAlertController(title: "Word not recognised", message: "You can't just make them up, you know!", preferredStyle: .Alert)
					ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
					presentViewController(ac, animated: true, completion: nil)
				}
			} else {
				let ac = UIAlertController(title: "Word used already", message: "Be more original!", preferredStyle: .Alert)
				ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
				presentViewController(ac, animated: true, completion: nil)
			}
		} else {
			let ac = UIAlertController(title: "Word not possible", message: "You can't spell that word from '\(title!.lowercaseString)'!", preferredStyle: .Alert)
			ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(ac, animated: true, completion: nil)
		}
	}

	func wordIsPossible(word: String) -> Bool {
		var tempWord = title!.lowercaseString

		for letter in word {
			if let pos = tempWord.rangeOfString(String(letter)) {
				if pos.isEmpty {
					return false
				} else {
					tempWord.removeAtIndex(pos.startIndex)
				}
			} else {
				return false
			}
		}

		return true
	}

	func wordIsOriginal(word: String) -> Bool {
		return !contains(objects, word)
	}

	func wordIsReal(word: NSString) -> Bool {
		let checker = UITextChecker()
		let range = NSMakeRange(0, word.length)
		let misspelledRange = checker.rangeOfMisspelledWordInString(word as String, range: range, startingAt: 0, wrap: false, language: "en")
		return misspelledRange.location == NSNotFound
	}

	func startGame() {
		allWords.shuffle()
		title = allWords[0]
		objects.removeAll(keepCapacity: true)
		tableView.reloadData()
	}


	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
		cell.textLabel!.text = objects[indexPath.row]
		return cell
	}
}

