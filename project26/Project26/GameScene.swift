//
//  GameScene.swift
//  Project26
//
//  Created by Hudzilla on 17/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
	case Player = 1
	case Wall = 2
	case Star = 4
	case Vortex = 8
	case Finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
	var player: SKSpriteNode!
	var lastTouchPosition: CGPoint?

	var motionManager: CMMotionManager!

	var scoreLabel: SKLabelNode!

	var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	var gameOver = false

    override func didMoveToView(view: SKView) {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = -1
		addChild(background)

		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .Left
		scoreLabel.position = CGPoint(x: 16, y: 16)
		addChild(scoreLabel)

		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		physicsWorld.contactDelegate = self

		loadLevel()
		createPlayer()

		motionManager = CMMotionManager()
		motionManager.startAccelerometerUpdates()
    }

	func loadLevel() {
		if let levelPath = NSBundle.mainBundle().pathForResource("level1", ofType: "txt") {
			if let levelString = try? String(contentsOfFile: levelPath, usedEncoding: nil) {
				let lines = levelString.componentsSeparatedByString("\n")

				for (row, line) in lines.reverse().enumerate() {
					for (column, letter) in line.characters.enumerate() {
						let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)

						if letter == "x" {
							// load wall
							let node = SKSpriteNode(imageNamed: "block")
							node.position = position

							node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
							node.physicsBody!.categoryBitMask = CollisionTypes.Wall.rawValue
							node.physicsBody!.dynamic = false
							addChild(node)
						} else if letter == "v"  {
							// load vortex
							let node = SKSpriteNode(imageNamed: "vortex")
							node.name = "vortex"
							node.position = position
							node.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)))
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody!.dynamic = false

							node.physicsBody!.categoryBitMask = CollisionTypes.Vortex.rawValue
							node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
							node.physicsBody!.collisionBitMask = 0
							addChild(node)
						} else if letter == "s"  {
							// load star
							let node = SKSpriteNode(imageNamed: "star")
							node.name = "star"
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody!.dynamic = false

							node.physicsBody!.categoryBitMask = CollisionTypes.Star.rawValue
							node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
							node.physicsBody!.collisionBitMask = 0
							node.position = position
							addChild(node)
						} else if letter == "f"  {
							// load finish
							let node = SKSpriteNode(imageNamed: "finish")
							node.name = "finish"
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody!.dynamic = false

							node.physicsBody!.categoryBitMask = CollisionTypes.Finish.rawValue
							node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
							node.physicsBody!.collisionBitMask = 0
							node.position = position
							addChild(node)
						}
					}
				}
			}
		}
	}

	func createPlayer() {
		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPoint(x: 96, y: 672)
		player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
		player.physicsBody!.allowsRotation = false
		player.physicsBody!.linearDamping = 0.5

		player.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
		player.physicsBody!.contactTestBitMask = CollisionTypes.Star.rawValue | CollisionTypes.Vortex.rawValue | CollisionTypes.Finish.rawValue
		player.physicsBody!.collisionBitMask = CollisionTypes.Wall.rawValue
		addChild(player)
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInNode(self)
			lastTouchPosition = location
		}
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInNode(self)
			lastTouchPosition = location
		}
	}

	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		lastTouchPosition = nil
	}

	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		lastTouchPosition = nil
	}

	override func update(currentTime: CFTimeInterval) {
		if !gameOver {
			#if (arch(i386) || arch(x86_64))
				if let currentTouch = lastTouchPosition {
					let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
					physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
				}
				#else
				if let accelerometerData = motionManager.accelerometerData {
					physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
				}
			#endif
		}
	}

	func didBeginContact(contact: SKPhysicsContact) {
		if contact.bodyA.node == player {
			playerCollidedWithNode(contact.bodyB.node!)
		} else if contact.bodyB.node == player {
			playerCollidedWithNode(contact.bodyA.node!)
		}
	}

	func playerCollidedWithNode(node: SKNode) {
		if node.name == "vortex" {
			player.physicsBody!.dynamic = false
			gameOver = true
			score -= 1

			let move = SKAction.moveTo(node.position, duration: 0.25)
			let scale = SKAction.scaleTo(0.0001, duration: 0.25)
			let remove = SKAction.removeFromParent()
			let sequence = SKAction.sequence([move, scale, remove])

			player.runAction(sequence) { [unowned self] in
				self.createPlayer()
				self.gameOver = false
			}
		} else if node.name == "star" {
			node.removeFromParent()
			score += 1
		} else if node.name == "finish" {
			// next level?
		}
	}
}
