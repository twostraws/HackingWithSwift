//
//  ViewController.swift
//  Project18
//
//  Created by TwoStraws on 18/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		print("I'm inside the viewDidLoad() method!")
		print(1, 2, 3, 4, 5, separator: "-")

		assert(1 == 1, "Maths failure!")

		for i in 1 ... 100 {
			print("Got number \(i)")
		}
	}
}

