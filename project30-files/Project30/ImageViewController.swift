//
//  ImageViewController.swift
//  Project30
//
//  Created by Hudzilla on 26/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
	var owner: SelectionViewController!
	var image: String!
	var animTimer: NSTimer!

	var imageView: UIImageView!

	override func loadView() {
		super.loadView()
		
		view.backgroundColor = UIColor.blackColor()

		// create an image view that fills the screen
		imageView = UIImageView()
		imageView.contentMode = .ScaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.alpha = 0

		view.addSubview(imageView)

		// make the image view fill the screen
		let viewsDictionary = ["imageView": imageView]
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: [], metrics:nil, views: viewsDictionary))
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: [], metrics:nil, views: viewsDictionary))

		// schedule an animation that does something vaguely interesting
		self.animTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "animateImage", userInfo: nil, repeats: true)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = image.stringByReplacingOccurrencesOfString(".jpg", withString: "")
		imageView.image = UIImage(named: image)

		// force the image to rasterize so we don't have to keep loading it at the original, large size
		imageView.layer.shouldRasterize = true
		imageView.layer.rasterizationScale = UIScreen.mainScreen().scale

		// NOTE: See if you can use the "Color hits green and misses red" option in the
		// Core Animation instrument to see what effect the above has in this project!
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		imageView.alpha = 0

		UIView.animateWithDuration(3) { [unowned self] in
			self.imageView.alpha = 1
		}
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let defaults = NSUserDefaults.standardUserDefaults()
		var currentVal = defaults.integerForKey(image) ?? 0
		++currentVal

		defaults.setInteger(currentVal, forKey:image)

		// tell the parent view controller that it should refresh its table counters when we go back
		owner.dirty = true
	}

	func animateImage() {
		// do something exciting with our image
		imageView.transform = CGAffineTransformIdentity

		UIView.animateWithDuration(3) { [unowned self] in
			self.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
