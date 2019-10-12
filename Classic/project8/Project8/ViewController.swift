//
//  ViewController.swift
//  Project8
//
//  Created by TwoStraws on 15/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var cluesLabel: UILabel!
	@IBOutlet var answersLabel: UILabel!
	@IBOutlet var currentAnswer: UITextField!
	@IBOutlet var scoreLabel: UILabel!

	var letterButtons = [UIButton]()
	var activatedButtons = [UIButton]()
	var solutions = [String]()

	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var level = 1

	override func viewDidLoad() {
		super.viewDidLoad()

		for subview in view.subviews where subview.tag == 1001 {
			let btn = subview as! UIButton
			letterButtons.append(btn)
			btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
		}

		loadLevel()
	}

	@objc func letterTapped(btn: UIButton) {
		currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
		activatedButtons.append(btn)
		btn.isHidden = true
	}

	func loadLevel() {
		var clueString = ""
		var solutionString = ""
		var letterBits = [String]()

		if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
			if let levelContents = try? String(contentsOfFile: levelFilePath) {
				var lines = levelContents.components(separatedBy: "\n")
				lines.shuffle()

				for (index, line) in lines.enumerated() {
					let parts = line.components(separatedBy: ": ")
					let answer = parts[0]
					let clue = parts[1]

					clueString += "\(index + 1). \(clue)\n"

					let solutionWord = answer.replacingOccurrences(of: "|", with: "")
					solutionString += "\(solutionWord.count) letters\n"
					solutions.append(solutionWord)

					let bits = answer.components(separatedBy: "|")
					letterBits += bits
				}
			}
		}

		cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
		answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

		letterBits.shuffle()

		if letterBits.count == letterButtons.count {
			for i in 0 ..< letterBits.count {
				letterButtons[i].setTitle(letterBits[i], for: .normal)
			}
		}
	}

	@IBAction func submitTapped(_ sender: AnyObject) {
		if let solutionPosition = solutions.index(of: currentAnswer.text!) {
			activatedButtons.removeAll()

			var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
			splitAnswers[solutionPosition] = currentAnswer.text!
			answersLabel.text = splitAnswers.joined(separator: "\n")

			currentAnswer.text = ""
			score += 1

			if score % 7 == 0 {
				let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
				present(ac, animated: true)
			}
		}
	}

	@IBAction func clearTapped(_ sender: AnyObject) {
		currentAnswer.text = ""

		for btn in activatedButtons {
			btn.isHidden = false
		}

		activatedButtons.removeAll()
	}

	func levelUp(action: UIAlertAction) {
		level += 1
		solutions.removeAll(keepingCapacity: true)

		loadLevel()

		for btn in letterButtons {
			btn.isHidden = false
		}
	}

}

