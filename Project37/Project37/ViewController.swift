//
//  ViewController.swift
//  Project37
//
//  Created by Hudzilla on 06/01/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import AVFoundation
import GameplayKit
import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
	@IBOutlet weak var cardContainer: UIView!
	@IBOutlet weak var gradientView: UIView!

	var allCards = [CardViewController]()
	var music: AVAudioPlayer!

	var lastMessage: CFAbsoluteTime = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.redColor()

		UIView.animateWithDuration(20, delay: 0, options: [.AllowUserInteraction, .Autoreverse, .Repeat], animations: {
			self.view.backgroundColor = UIColor.blueColor()
		}, completion: nil)

		createParticles()		
		loadCards()
		playMusic()

		if (WCSession.isSupported()) {
			let session = WCSession.defaultSession()
			session.delegate = self
			session.activateSession()
		}
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		let instructions = "Please ensure your Apple Watch is configured correctly. On your iPhone, launch Apple's 'Watch' configuration app then choose General > Wake Screen. On that screen, please disable Wake Screen On Wrist Raise, then select Wake For 70 Seconds. On your Apple Watch, please swipe up on your watch face and enable Silent Mode. You're done!"
		let ac = UIAlertController(title: "Adjust your settings", message: instructions, preferredStyle: .Alert)
		ac.addAction(UIAlertAction(title: "I'm Ready", style: .Default, handler: nil))
		presentViewController(ac, animated: true, completion: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func loadCards() {
		for card in allCards {
			card.view.removeFromSuperview()
			card.removeFromParentViewController()
		}

		allCards.removeAll(keepCapacity: true)

		view.userInteractionEnabled = true

		// create an array of card positions
		let positions = [
			CGPoint(x: 75, y: 85),
			CGPoint(x: 185, y: 85),
			CGPoint(x: 295, y: 85),
			CGPoint(x: 405, y: 85),
			CGPoint(x: 75, y: 235),
			CGPoint(x: 185, y: 235),
			CGPoint(x: 295, y: 235),
			CGPoint(x: 405, y: 235)
		]

		// load and unwrap our Zener card images
		let circle = UIImage(named: "cardCircle")!
		let cross = UIImage(named: "cardCross")!
		let lines = UIImage(named: "cardLines")!
		let square = UIImage(named: "cardSquare")!
		let star = UIImage(named: "cardStar")!

		// create an array of the images, one for each card, then shuffle it
		var images = [circle, circle, cross, cross, lines, lines, square, star]
		images = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(images) as! [UIImage]

		for (index, position) in positions.enumerate() {
			// loop over each card position and create a new card view controller
			let card = CardViewController()
			card.delegate = self

			// use view controller containment and also add the card's view to our cardContainer view
			addChildViewController(card)
			cardContainer.addSubview(card.view)
			card.didMoveToParentViewController(self)

			// position the card appropriately, then give it an image from our array
			card.view.center = position
			card.front.image = images[index]

			// if we just gave the new card the star image, mark this as the correct answer
			if card.front.image == star {
				card.isCorrect = true
			}

			// add the new card view controller to our array for easier tracking
			allCards.append(card)
		}
	}

	func cardTapped(tapped: CardViewController) {
		guard view.userInteractionEnabled == true else { return }
		view.userInteractionEnabled = false

		for card in allCards {
			if card == tapped {
				card.wasTapped()
				card.performSelector(#selector(card.wasntTapped), withObject: nil, afterDelay: 1)
			} else {
				card.wasntTapped()
			}
		}

		performSelector(#selector(loadCards), withObject: nil, afterDelay: 2)
	}

	func createParticles() {
		let particleEmitter = CAEmitterLayer()

		particleEmitter.emitterPosition = CGPoint(x: view.frame.width / 2.0, y: -50)
		particleEmitter.emitterShape = kCAEmitterLayerLine
		particleEmitter.emitterSize = CGSize(width: view.frame.width, height: 1)
		particleEmitter.renderMode = kCAEmitterLayerAdditive

		let cell = CAEmitterCell()
		cell.birthRate = 2
		cell.lifetime = 5.0
		cell.velocity = 100
		cell.velocityRange = 50
		cell.emissionLongitude = CGFloat(M_PI)
		cell.spinRange = 5
		cell.scale = 0.5
		cell.scaleRange = 0.25
		cell.color = UIColor(white: 1, alpha: 0.1).CGColor
		cell.alphaSpeed = -0.025
		cell.contents = UIImage(named: "particle")?.CGImage
		particleEmitter.emitterCells = [cell]

		gradientView.layer.addSublayer(particleEmitter)
	}

	func playMusic() {
		if let musicURL = NSBundle.mainBundle().URLForResource("PhantomFromSpace", withExtension: "mp3") {
			if let audioPlayer = try? AVAudioPlayer(contentsOfURL: musicURL) {
				music = audioPlayer
				music.numberOfLoops = -1
				music.play()
			}
		}
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)

		if let touch = touches.first {
			let location = touch.locationInView(cardContainer)

			for card in allCards {
				if card.view.frame.contains(location) {
					if view.traitCollection.forceTouchCapability == .Available {
						if touch.force == touch.maximumPossibleForce {
							card.front.image = UIImage(named: "cardStar")
							card.isCorrect = true
						}
					}

					if card.isCorrect {
						sendWatchMessage()
					}
				}
			}
		}
	}

	func sendWatchMessage() {
		let currentTime = CFAbsoluteTimeGetCurrent()

		// if less than half a second has passed, bail out
		if lastMessage + 0.5 > currentTime {
			return
		}

		// send a message to the watch if it's reachable
		if (WCSession.defaultSession().reachable) {
			let message = ["Message": "Hello"]
			WCSession.defaultSession().sendMessage(message, replyHandler: nil, errorHandler: nil)
		}

		// update our rate limiting property
		lastMessage = CFAbsoluteTimeGetCurrent()
	}
}

