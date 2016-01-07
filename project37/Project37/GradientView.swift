//
//  GradientView.swift
//  Project37
//
//  Created by Hudzilla on 06/01/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
	@IBInspectable var topColor: UIColor = UIColor.whiteColor()
	@IBInspectable var bottomColor: UIColor = UIColor.blackColor()

	override class func layerClass() -> AnyClass {
		return CAGradientLayer.self
	}

	override func layoutSubviews() {
		(layer as! CAGradientLayer).colors = [topColor.CGColor, bottomColor.CGColor]
	}
}