//
//  ViewController.swift
//  Project27
//
//  Created by TwoStraws on 19/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!

	var currentDrawType = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		drawRectangle()
	}

	@IBAction func redrawTapped(_ sender: AnyObject) {
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
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { ctx in
			let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

			ctx.cgContext.setFillColor(UIColor.red.cgColor)
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.setLineWidth(10)

			ctx.cgContext.addRect(rectangle)
			ctx.cgContext.drawPath(using: .fillStroke)
		}

		imageView.image = img
	}

	func drawCircle() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { ctx in
			let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502)

			ctx.cgContext.setFillColor(UIColor.red.cgColor)
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.setLineWidth(10)

			ctx.cgContext.addEllipse(in: rectangle)
			ctx.cgContext.drawPath(using: .fillStroke)
		}

		imageView.image = img
	}

	func drawCheckerboard() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { ctx in
			ctx.cgContext.setFillColor(UIColor.black.cgColor)

			for row in 0 ..< 8 {
				for col in 0 ..< 8 {
					if (row + col) % 2 == 0 {
						ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
					}
				}
			}
		}

		imageView.image = img
	}

	func drawRotatedSquares() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { ctx in
			ctx.cgContext.translateBy(x: 256, y: 256)

			let rotations = 16
			let amount = Double.pi / Double(rotations)

			for _ in 0 ..< rotations {
				ctx.cgContext.rotate(by: CGFloat(amount))
				ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
			}

			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.strokePath()
		}

		imageView.image = img
	}

	func drawLines() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { ctx in
			ctx.cgContext.translateBy(x: 256, y: 256)

			var first = true
			var length: CGFloat = 256

			for _ in 0 ..< 256 {
				ctx.cgContext.rotate(by: CGFloat.pi / 2)

				if first {
					ctx.cgContext.move(to: CGPoint(x: length, y: 50))
					first = false
				} else {
					ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
				}

				length *= 0.99
			}

			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.strokePath()
		}

		imageView.image = img
	}

	func drawImagesAndText() {
		// 1
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

		let img = renderer.image { ctx in
			// 2
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center

			// 3
            let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]

			// 4
			let string = "The best-laid schemes o'\nmice an' men gang aft agley"
			string.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)

			// 5
			let mouse = UIImage(named: "mouse")
			mouse?.draw(at: CGPoint(x: 300, y: 150))
		}

		// 6
		imageView.image = img
	}
}

