//
//  GameScene.swift
//  Project17
//
//  Created by Hudzilla on 23/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import AVFoundation
import SpriteKit

enum SequenceType: Int {
	case OneNoBomb, One, TwoWithOneBomb, Two, Three, Four, Chain, FastChain
}

enum ForceBomb {
	case Never, Always, Default
}

class GameScene: SKScene {
	var swooshSoundActive = false

	var activeSliceBG: SKShapeNode!
	var activeSliceFG: SKShapeNode!
	var activeSlicePoints = [CGPoint]()
	var activeEnemies = [SKSpriteNode]()

	var popupTime = 0.9
	var sequence: [SequenceType]!
	var sequencePosition = 0
	var chainDelay = 3.0
	var nextSequenceQueued = true

	var gameEnded = false

	var bombSoundEffect: AVAudioPlayer!

	var gameScore: SKLabelNode!
	var score: Int = 0{
		didSet {
			gameScore.text = "Score: \(score)"
		}
	}

	var livesImages = [SKSpriteNode]()
	var lives = 3

	override func didMoveToView(view: SKView) {
		sequence = [.OneNoBomb, .OneNoBomb, .TwoWithOneBomb, .TwoWithOneBomb, .Three, .One, .Chain]

		for i in 0 ... 1000 {
			var nextSequence = SequenceType(rawValue: RandomInt(min: 2, max: 7))!
			sequence.append(nextSequence)
		}

		let background = SKSpriteNode(imageNamed: "sliceBackground")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		addChild(background)

		physicsWorld.gravity = CGVector(dx: 0, dy: -6)
		physicsWorld.speed = 0.85

		createScore()
		createLives()
		createSlices()

		runAfterDelay(2) { [unowned self] in
			self.tossEnemies()
		}
	}

	func createScore() {
		gameScore = SKLabelNode(fontNamed: "Chalkduster")
		gameScore.text = "Score: 0"
		gameScore.horizontalAlignmentMode = .Left
		gameScore.fontSize = 48

		addChild(gameScore)

		gameScore.position = CGPoint(x: 8, y: 8)
	}

	func createLives() {
		for i in 0 ..< 3 {
			let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
			spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
			addChild(spriteNode)

			livesImages.append(spriteNode)
		}
	}

	func createSlices() {
		activeSliceBG = SKShapeNode()
		activeSliceBG.zPosition = 2

		activeSliceFG = SKShapeNode()
		activeSliceFG.zPosition = 2

		activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
		activeSliceBG.lineWidth = 9

		activeSliceFG.strokeColor = UIColor.whiteColor()
		activeSliceFG.lineWidth = 5

		addChild(activeSliceBG)
		addChild(activeSliceFG)
	}

	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		super.touchesBegan(touches, withEvent: event)

		activeSlicePoints.removeAll(keepCapacity: true)

		let touch = touches.anyObject() as UITouch
		let location = touch.locationInNode(self)
		let nodes = nodesAtPoint(location) as [SKNode]

		activeSlicePoints.append(location)
		redrawActiveSlice()

		// just in case these are still alphaing out…
		activeSliceBG.removeAllActions()
		activeSliceFG.removeAllActions()

		activeSliceBG.alpha = 1
		activeSliceFG.alpha = 1
	}

	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		if gameEnded { return }

		let touch = touches.anyObject() as UITouch
		let location = touch.locationInNode(self)

		activeSlicePoints.append(location)
		redrawActiveSlice()

		if !swooshSoundActive {
			playSwooshSound()
		}

		let nodes = nodesAtPoint(location) as [SKNode]

		for node in nodes {
			if node.name == "enemy" {
				let explosionPath = NSBundle.mainBundle().pathForResource("sliceHitEnemy", ofType: "sks")!
				let emitter = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionPath) as SKEmitterNode
				emitter.position = node.position
				addChild(emitter)

				node.name = ""
				node.physicsBody!.dynamic = false

				let scaleOut = SKAction.scaleTo(0.001, duration:0.2)
				let fadeOut = SKAction.fadeOutWithDuration(0.2)
				let group = SKAction.group([scaleOut, fadeOut])

				let seq = SKAction.sequence([group, SKAction.removeFromParent()])

				node.runAction(seq)

				++score

				let index = find(activeEnemies, node as SKSpriteNode)!
				activeEnemies.removeAtIndex(index)

				runAction(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
			} else if node.name == "bomb" {
				// when working with a bomb, it's actually a node with two nodes inside it:
				// the bomb image (the one with the name "bomb") and the spark effect.
				// This is because if we added the spark particles directly to the "bomb" image
				// node, all the sparks become sliceable as if we'd hit the bomb - it's silly.
				let explosionPath = NSBundle.mainBundle().pathForResource("sliceHitBomb", ofType: "sks")!
				let emitter = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionPath) as SKEmitterNode
				emitter.position = node.parent!.position
				addChild(emitter)

				node.name = ""
				node.parent!.physicsBody!.dynamic = false

				let scaleOut = SKAction.scaleTo(0.001, duration:0.2)
				let fadeOut = SKAction.fadeOutWithDuration(0.2)
				let group = SKAction.group([scaleOut, fadeOut])

				let seq = SKAction.sequence([group, SKAction.removeFromParent()])

				node.parent!.runAction(seq)

				let index = find(activeEnemies, node.parent as SKSpriteNode)!
				activeEnemies.removeAtIndex(index)

				runAction(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
				endGame(triggeredByBomb: true)
			}
		}
	}

	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		activeSliceBG.runAction(SKAction.fadeOutWithDuration(0.25))
		activeSliceFG.runAction(SKAction.fadeOutWithDuration(0.25))
	}

	override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
		touchesEnded(touches, withEvent: event)
	}

	func playSwooshSound() {
		swooshSoundActive = true

		var randomNumber = RandomInt(min: 1, max: 3)
		var soundName = "swoosh\(randomNumber).caf"

		let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)

		runAction(swooshSound) { [unowned self] in
			self.swooshSoundActive = false
		}
	}

	func redrawActiveSlice() {
		if activeSlicePoints.count < 2 {
			activeSliceBG.path = nil
			activeSliceFG.path = nil
			return
		}

		while self.activeSlicePoints.count > 12 {
			activeSlicePoints.removeAtIndex(0)
		}

		var path = UIBezierPath()
		path.moveToPoint(activeSlicePoints[0])

		for var i = 1; i < activeSlicePoints.count; ++i {
			path.addLineToPoint(activeSlicePoints[i])
		}

		self.activeSliceBG.path = path.CGPath
		self.activeSliceFG.path = path.CGPath
	}

	func tossEnemies() {
		if gameEnded {
			return
		}

		// these two combined make the whole game get faster and faster until they are eventually guaranteed to lose
		popupTime *= 0.991
		chainDelay *= 0.99
		physicsWorld.speed *= 1.02

		let sequenceType = sequence[sequencePosition]

		switch sequenceType {
		case .OneNoBomb:
			createEnemy(forceBomb: .Never)

		case .One:
			createEnemy()

		case .TwoWithOneBomb:
			createEnemy(forceBomb: .Never)
			createEnemy(forceBomb: .Always)

		case .Two:
			createEnemy()
			createEnemy()

		case .Three:
			createEnemy()
			createEnemy()
			createEnemy()

		case .Four:
			createEnemy()
			createEnemy()
			createEnemy()
			createEnemy()

		case .Chain:
			createEnemy()

			runAfterDelay(chainDelay / 5.0) { [unowned self] in self.createEnemy() }
			runAfterDelay(chainDelay / 5.0 * 2) { [unowned self] in self.createEnemy() }
			runAfterDelay(chainDelay / 5.0 * 3) { [unowned self] in self.createEnemy() }
			runAfterDelay(chainDelay / 5.0 * 4) { [unowned self] in self.createEnemy() }

		case .FastChain:
			createEnemy()

			runAfterDelay(chainDelay / 10.0) { [unowned self] in self.createEnemy() }
			runAfterDelay(chainDelay / 10.0 * 2) { [unowned self] in self.createEnemy() }
			runAfterDelay(chainDelay / 10.0 * 3) { [unowned self] in self.createEnemy() }
			runAfterDelay(chainDelay / 10.0 * 4) { [unowned self] in self.createEnemy() }
		}


		++sequencePosition

		nextSequenceQueued = false
	}

	func createEnemy(forceBomb: ForceBomb = .Default) {
		var enemy: SKSpriteNode

		var enemyType = RandomInt(min: 0, max: 6)

		if forceBomb == .Never {
			enemyType = 1
		} else if forceBomb == .Always {
			enemyType = 0
		}

		if enemyType == 0 {
			// we're creating a bomb, which is a bit special: we need to create an empty node
			// and place inside it the bomb picture (called "bomb" so that it's the sliceable bit)
			// and the spark particle emitter. If we put the sparks directly inside the bomb image
			// then the sparks respond to being sliced, which makes it impossible to play.
			enemy = SKSpriteNode()
			enemy.zPosition = 1 // always force bombs to be in front of enemies but behind the slice shape node
			enemy.name = "bombContainer"

			let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
			bombImage.name = "bomb"
			enemy.addChild(bombImage)

			if bombSoundEffect != nil {
				bombSoundEffect.stop()
				bombSoundEffect = nil
			}

			let path = NSBundle.mainBundle().pathForResource("sliceBombFuse.caf", ofType:nil)!
			let url = NSURL(fileURLWithPath: path)

			let sound = AVAudioPlayer(contentsOfURL: url, error: nil)
			bombSoundEffect = sound
			sound.play()

			let particlePath = NSBundle.mainBundle().pathForResource("sliceFuse", ofType: "sks")!
			let emitter = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath) as SKEmitterNode
			emitter.position = CGPoint(x: 76, y: 64)
			enemy.addChild(emitter)
		} else {
			enemy = SKSpriteNode(imageNamed: "penguin")
			runAction(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
			enemy.name = "enemy"
		}

		let randomPosition = CGPoint(x: RandomInt(min: 64, max: 960), y: -128)
		enemy.position = randomPosition

		let	randomAngularVelocity = CGFloat(RandomInt(min: -6, max: 6)) / 2.0
		var randomXVelocity = 0

		if randomPosition.x < 256 {
			randomXVelocity = RandomInt(min: 8, max: 15)
		} else if randomPosition.x < 512 {
			randomXVelocity = RandomInt(min: 3, max: 5)
		} else if randomPosition.x < 768 {
			randomXVelocity = -RandomInt(min: 3, max: 5)
		} else {
			randomXVelocity = -RandomInt(min: 8, max: 15)
		}

		let randomYVelocity = RandomInt(min: 24, max: 32)

		enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
		enemy.physicsBody!.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
		enemy.physicsBody!.angularVelocity = randomAngularVelocity
		enemy.physicsBody!.collisionBitMask = 0

		addChild(enemy)
		activeEnemies.append(enemy)
	}

	override func update(currentTime: NSTimeInterval) {
		super.update(currentTime)

		if activeEnemies.count > 0 {
			for node in activeEnemies {
				if node.position.y < -140 {
					node.removeAllActions()

					if node.name == "enemy" {
						node.name = ""
						subtractLife()

						node.removeFromParent()

						if let index = find(activeEnemies, node) {
							activeEnemies.removeAtIndex(index)
						}
					} else if node.name == "bombContainer" {
						node.name = ""
						node.removeFromParent()

						if let index = find(activeEnemies, node) {
							activeEnemies.removeAtIndex(index)
						}
					}
				}
			}
		} else {
			if !self.nextSequenceQueued {
				runAfterDelay(popupTime) { [unowned self] in
					self.tossEnemies()
				}

				nextSequenceQueued = true
			}
		}

		var bombCount = 0

		for node in activeEnemies {
			if node.name == "bombContainer" {
				++bombCount
				break
			}
		}

		if bombCount == 0 {
			// no bombs - stop the fuse sound!
			if bombSoundEffect != nil {
				bombSoundEffect.stop()
				bombSoundEffect = nil
			}
		}
	}

	func subtractLife() {
		--lives

		runAction(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))

		var life: SKSpriteNode

		if lives == 2 {
			life = livesImages[0]
		} else if lives == 1 {
			life = livesImages[1]
		} else {
			life = livesImages[2]
			endGame(triggeredByBomb: false)
		}

		life.texture = SKTexture(imageNamed: "sliceLifeGone")

		life.xScale = 1.3
		life.yScale = 1.3
		life.runAction(SKAction.scaleTo(1, duration:0.1))
	}

	func endGame(#triggeredByBomb: Bool) {
		if gameEnded {
			return
		}

		gameEnded = true
		physicsWorld.speed = 0
		userInteractionEnabled = false

		if bombSoundEffect != nil {
			bombSoundEffect.stop()
			bombSoundEffect = nil
		}

		if triggeredByBomb {
			livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
			livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
			livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
		}
	}
}
