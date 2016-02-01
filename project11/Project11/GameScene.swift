//
//  GameScene.swift
//  Project11
//
//  Created by Hudzilla on 15/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	var scoreLabel: SKLabelNode!

	var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	var editLabel: SKLabelNode!

	var editingMode: Bool = false {
		didSet {
			if editingMode {
				editLabel.text = "Done"
			} else {
				editLabel.text = "Edit"
			}
		}
	}

    override func didMoveToView(view: SKView) {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = -1
		addChild(background)

		physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
		physicsWorld.contactDelegate = self

		makeSlotAt(CGPoint(x: 128, y: 0), isGood: true)
		makeSlotAt(CGPoint(x: 384, y: 0), isGood: false)
		makeSlotAt(CGPoint(x: 640, y: 0), isGood: true)
		makeSlotAt(CGPoint(x: 896, y:0), isGood: false)

		makeBouncerAt(CGPoint(x: 0, y: 0))
		makeBouncerAt(CGPoint(x: 256, y: 0))
		makeBouncerAt(CGPoint(x: 512, y: 0))
		makeBouncerAt(CGPoint(x: 768, y: 0))
		makeBouncerAt(CGPoint(x: 1024, y: 0))

		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .Right
		scoreLabel.position = CGPoint(x: 980, y: 700)
		addChild(scoreLabel)

		editLabel = SKLabelNode(fontNamed: "Chalkduster")
		editLabel.text = "Edit"
		editLabel.position = CGPoint(x: 80, y: 700)
		addChild(editLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInNode(self)

			let objects = nodesAtPoint(location) as [SKNode]

			if objects.contains(editLabel) {
				editingMode = !editingMode
			} else {
				if editingMode {
					let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
					let box = SKSpriteNode(color: RandomColor(), size: size)
					box.zRotation = RandomCGFloat(min: 0, max: 3)
					box.position = location

					box.physicsBody = SKPhysicsBody(rectangleOfSize: box.size)
					box.physicsBody!.dynamic = false
					
					addChild(box)
				} else {
					let ball = SKSpriteNode(imageNamed: "ballRed")
					ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
					ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
					ball.physicsBody!.restitution = 0.4
					ball.position = location
					ball.name = "ball"
					addChild(ball)
				}
			}
		}
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

	func makeBouncerAt(position: CGPoint) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
		bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
		bouncer.physicsBody!.dynamic = false
		addChild(bouncer)
	}

	func makeSlotAt(position: CGPoint, isGood: Bool) {
		var slotBase: SKSpriteNode
		var slotGlow: SKSpriteNode

		if isGood {
			slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
			slotBase.name = "good"
		} else {
			slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
			slotBase.name = "bad"
		}

		slotBase.position = position
		slotGlow.position = position

		slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
		slotBase.physicsBody!.dynamic = false

		addChild(slotBase)
		addChild(slotGlow)

		let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
		let spinForever = SKAction.repeatActionForever(spin)
		slotGlow.runAction(spinForever)
	}

	func didBeginContact(contact: SKPhysicsContact) {
		if contact.bodyA.node!.name == "ball" {
			collisionBetweenBall(contact.bodyA.node!, object: contact.bodyB.node!)
		} else if contact.bodyB.node!.name == "ball" {
			collisionBetweenBall(contact.bodyB.node!, object: contact.bodyA.node!)
		}
	}

	func collisionBetweenBall(ball: SKNode, object: SKNode) {
		if object.name == "good" {
			destroyBall(ball)
			score += 1
		} else if object.name == "bad" {
			destroyBall(ball)
			score -= 1
		}
	}

	func destroyBall(ball: SKNode) {
		if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
			fireParticles.position = ball.position
			addChild(fireParticles)
		}

		ball.removeFromParent()
	}
}
