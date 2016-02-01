//
//  ViewController.swift
//  Project27
//
//  Created by Hudzilla on 17/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!

	var currentDrawType = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		drawRectangle()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func redrawTapped(sender: AnyObject) {
		currentDrawType += 1

		if currentDrawType > 5 {
			currentDrawType = 0
		}

		switch currentDrawType {
		case 0:
			drawRectangle()

		case 1:
			drawCircle()

		case 2:
			drawCheckerboard()

		case 3:
			drawRotatedSquares()

		case 4:
			drawLines()

		case 5:
			drawImagesAndText()

		default:
			break
		}
	}

	func drawRectangle() {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let context = UIGraphicsGetCurrentContext()

		let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

		CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
		CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
		CGContextSetLineWidth(context, 10)

		CGContextAddRect(context, rectangle)
		CGContextDrawPath(context, .FillStroke)

		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		imageView.image = img
	}

	func drawCircle() {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let context = UIGraphicsGetCurrentContext()
		let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502)

		CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
		CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
		CGContextSetLineWidth(context, 10)

		CGContextAddEllipseInRect(context, rectangle)
		CGContextDrawPath(context, .FillStroke)

		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		imageView.image = img
	}

	func drawCheckerboard() {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let context = UIGraphicsGetCurrentContext()

		CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)

		for row in 0 ..< 8 {
			for col in 0 ..< 8 {
				if row % 2 == 0 {
					if col % 2 == 0 {
						CGContextFillRect(context, CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
					}
				} else {
					if col % 2 == 1 {
						CGContextFillRect(context, CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
					}
				}

			}
		}

		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		imageView.image = img
	}

	func drawRotatedSquares() {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let context = UIGraphicsGetCurrentContext()
		CGContextTranslateCTM(context, 256, 256)

		let rotations = 16
		let amount = M_PI_2 / Double(rotations)

		for _ in 0 ..< rotations {
			CGContextRotateCTM(context, CGFloat(amount))
			CGContextAddRect(context, CGRect(x: -128, y: -128, width: 256, height: 256))
		}

		CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
		CGContextStrokePath(context)

		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		imageView.image = img
	}

	func drawLines() {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let context = UIGraphicsGetCurrentContext()
		CGContextTranslateCTM(context, 256, 256)

		var first = true
		var length: CGFloat = 256

		for _ in 0 ..< 256 {
			CGContextRotateCTM(context, CGFloat(M_PI_2))

			if first {
				CGContextMoveToPoint(context, length, 50)
				first = false
			} else {
				CGContextAddLineToPoint(context, length, 50)
			}

			length *= 0.99
		}

		CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
		CGContextStrokePath(context)

		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		imageView.image = img
	}

	func drawImagesAndText() {
		// 1
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)

		// 2
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .Center

		// 3
		let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSParagraphStyleAttributeName: paragraphStyle]

		// 4
		let string = "The best-laid schemes o'\nmice an' men gang aft agley"
		string.drawWithRect(CGRect(x: 32, y: 32, width: 448, height: 448), options: .UsesLineFragmentOrigin, attributes: attrs, context: nil)

		// 5
		let mouse = UIImage(named: "mouse")
		mouse?.drawAtPoint(CGPoint(x: 300, y: 150))

		// 6
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		// 7
		imageView.image = img
	}
}

