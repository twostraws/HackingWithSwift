//
//  ViewController.swift
//  Project6b
//
//  Created by Hudzilla on 20/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let label1 = UILabel()
		label1.setTranslatesAutoresizingMaskIntoConstraints(false)
		label1.backgroundColor = UIColor.redColor()
		label1.text = "THESE"

		let label2 = UILabel()
		label2.setTranslatesAutoresizingMaskIntoConstraints(false)
		label2.backgroundColor = UIColor.cyanColor()
		label2.text = "ARE"

		let label3 = UILabel()
		label3.setTranslatesAutoresizingMaskIntoConstraints(false)
		label3.backgroundColor = UIColor.yellowColor()
		label3.text = "SOME"

		let label4 = UILabel()
		label4.setTranslatesAutoresizingMaskIntoConstraints(false)
		label4.backgroundColor = UIColor.greenColor()
		label4.text = "AWESOME"

		let label5 = UILabel()
		label5.setTranslatesAutoresizingMaskIntoConstraints(false)
		label5.backgroundColor = UIColor.orangeColor()
		label5.text = "LABELS"

		view.addSubview(label1)
		view.addSubview(label2)
		view.addSubview(label3)
		view.addSubview(label4)
		view.addSubview(label5)

		let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]

		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label1]|", options: .allZeros, metrics: nil, views: viewsDictionary))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label2]|", options: .allZeros, metrics: nil, views: viewsDictionary))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label3]|", options: .allZeros, metrics: nil, views: viewsDictionary))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label4]|", options: .allZeros, metrics: nil, views: viewsDictionary))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label5]|", options: .allZeros, metrics: nil, views: viewsDictionary))

//		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label1]-[label2]-[label3]-[label4]-[label5]", options: .allZeros, metrics: nil, views: viewsDictionary))
//		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label1(==88)]-[label2(==88)]-[label3(==88)]-[label4(==88)]-[label5(==88)]-(>=10)-|", options: .allZeros, metrics: nil, views: viewsDictionary))
//		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label1(labelHeight)]-[label2(labelHeight)]-[label3(labelHeight)]-[label4(labelHeight)]-[label5(labelHeight)]->=10-|", options: .allZeros, metrics: ["labelHeight": 88], views: viewsDictionary))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: .allZeros, metrics: ["labelHeight": 88], views: viewsDictionary))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}

