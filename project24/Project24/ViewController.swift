//
//  ViewController.swift
//  Project24
//
//  Created by Hudzilla on 25/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = UIColor.chartreuseColor()
		
		var meh = "      MEH       "
		meh.trim()
		NSLog("%@", meh)

		var i = 1
		i.plusOne()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

