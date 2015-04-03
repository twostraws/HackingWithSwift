//
//  ViewController.swift
//  Project2
//
//  Created by Hudzilla on 19/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var button1: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button3: UIButton!

	var countries = [String]()
	var correctAnswer = 0
	var score = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		countries.append("estonia")
		countries.append("france")
		countries.append("germany")
		countries.append("ireland")
		countries.append("italy")
		countries.append("monaco")
		countries.append("nigeria")
		countries.append("poland")
		countries.append("russia")
		countries.append("spain")
		countries.append("uk")
		countries.append("us")

		button1.layer.borderWidth = 1
		button2.layer.borderWidth = 1
		button3.layer.borderWidth = 1

		askQuestion(nil)
	}

	func askQuestion(action: UIAlertAction!) {
		countries.shuffle()

		button1.setImage(UIImage(named: countries[0]), forState: .Normal)
		button2.setImage(UIImage(named: countries[1]), forState: .Normal)
		button3.setImage(UIImage(named: countries[2]), forState: .Normal)

		correctAnswer = Int(arc4random_uniform(3))

		title = countries[correctAnswer].uppercaseString
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func buttonTapped(sender: UIButton) {
		var title: String

		if sender.tag == correctAnswer {
			title = "Correct"
			++score
		} else {
			title = "Wrong"
			--score
		}

		let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .Alert)
		ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: askQuestion))
		presentViewController(ac, animated: true, completion: nil)
	}

}

