//
//  ViewController.swift
//  Project8
//
//  Created by Hudzilla on 20/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var cluesLabel: UILabel!
	@IBOutlet weak var answersLabel: UILabel!
	@IBOutlet weak var currentAnswer: UITextField!
	@IBOutlet weak var scoreLabel: UILabel!

	var letterButtons = [UIButton]()
	var activatedButtons = [UIButton]()
	var solutions = [String]()

	var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	var level = 1

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		for subview in view.subviews {
			if subview.tag == 1001 {
				let btn = subview as! UIButton
				letterButtons.append(btn)
				btn.addTarget(self, action: "letterTapped:", forControlEvents: .TouchUpInside)
			}
		}

		loadLevel()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func submitTapped(sender: AnyObject) {
		if let solutionPosition = find(solutions, currentAnswer.text) {
			activatedButtons.removeAll()

			var splitClues = answersLabel.text!.componentsSeparatedByString("\n")
			splitClues[solutionPosition] = currentAnswer.text
			answersLabel.text = join("\n", splitClues)

			currentAnswer.text = ""

			++score

			if score % 7 == 0 {
				let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .Alert)
				ac.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
				presentViewController(ac, animated: true, completion: nil)
			}
		}
	}

	@IBAction func clearTapped(sender: AnyObject) {
		currentAnswer.text = ""

		for btn in activatedButtons {
			btn.hidden = false
		}

		activatedButtons.removeAll()
	}

	func loadLevel() {
		var clueString = ""
		var solutionString = ""
		var letterBits = [String]()

		if let levelFilePath = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt") {
			if let levelContents = NSString(contentsOfFile: levelFilePath, usedEncoding: nil, error: nil) {
				var lines = levelContents.componentsSeparatedByString("\n")
				lines.shuffle()

				for (index, line) in enumerate(lines as! [String]) {
					let parts = line.componentsSeparatedByString(": ")
					let answer = parts[0]
					let clue = parts[1]

					clueString += "\(index + 1). \(clue)\n"

					let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "")
					solutionString += "\(count(solutionWord)) letters\n"
					solutions.append(solutionWord)

					let bits = answer.componentsSeparatedByString("|")
					letterBits += bits
				}
			}
		}

		cluesLabel.text = clueString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
		answersLabel.text = solutionString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())

		letterBits.shuffle()
		letterButtons.shuffle()

		if letterBits.count == letterButtons.count {
			for i in 0 ..< letterBits.count {
				letterButtons[i].setTitle(letterBits[i], forState: .Normal)
			}
		}
	}

	func letterTapped(btn: UIButton) {
		currentAnswer.text = currentAnswer.text + btn.titleLabel!.text!
		activatedButtons.append(btn)
		btn.hidden = true
	}

	func levelUp(action: UIAlertAction!) {
//		++level //  we only have one level!

		solutions.removeAll(keepCapacity: true)		
		loadLevel()

		for btn in letterButtons {
			btn.hidden = false
		}
	}
}

