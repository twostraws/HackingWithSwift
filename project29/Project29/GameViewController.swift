//
//  GameViewController.swift
//  Project29
//
//  Created by Hudzilla on 17/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
	var currentGame: GameScene!

	@IBOutlet weak var angleSlider: UISlider!
	@IBOutlet weak var angleLabel: UILabel!

	@IBOutlet weak var velocitySlider: UISlider!
	@IBOutlet weak var velocityLabel: UILabel!

	@IBOutlet weak var launchButton: UIButton!
	@IBOutlet weak var playerNumber: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

		angleChanged(angleSlider)
		velocityChanged(velocitySlider)

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)

			currentGame = scene
			scene.viewController = self
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

	@IBAction func angleChanged(sender: AnyObject) {
		angleLabel.text = "Angle: \(Int(angleSlider.value))°"
	}

	@IBAction func velocityChanged(sender: AnyObject) {
		velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
	}

	@IBAction func launch(sender: AnyObject) {
		angleSlider.hidden = true
		angleLabel.hidden = true

		velocitySlider.hidden = true
		velocityLabel.hidden = true

		launchButton.hidden = true

		currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
	}

	func activatePlayerNumber(number: Int) {
		if number == 1 {
			playerNumber.text = "<<< PLAYER ONE"
		} else {
			playerNumber.text = "PLAYER TWO >>>"
		}

		angleSlider.hidden = false
		angleLabel.hidden = false

		velocitySlider.hidden = false
		velocityLabel.hidden = false

		launchButton.hidden = false
	}
}
