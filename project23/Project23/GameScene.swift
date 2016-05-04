//
//  GameScene.swift
//  Project23
//
//  Created by Hudzilla on 16/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	var starfield: SKEmitterNode!
	var player: SKSpriteNode!

	var possibleEnemies = ["ball", "hammer", "tv"]
	var gameTimer: NSTimer!
	var gameOver = false

	var scoreLabel: SKLabelNode!
	var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}

	override func didMoveToView(view: SKView) {
		backgroundColor = UIColor.blackColor()

		starfield = SKEmitterNode(fileNamed: "Starfield")!
		starfield.position = CGPoint(x: 1024, y: 384)
		starfield.advanceSimulationTime(10)
		addChild(starfield)
		starfield.zPosition = -1

		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPoint(x: 100, y: 384)
		player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
		player.physicsBody!.contactTestBitMask = 1
		addChild(player)

		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.position = CGPoint(x: 16, y: 16)
		scoreLabel.horizontalAlignmentMode = .Left
		addChild(scoreLabel)

		score = 0

		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		physicsWorld.contactDelegate = self

		gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
	}

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
   
	override func update(currentTime: CFTimeInterval) {
		for node in children {
			if node.position.x < -300 {
				node.removeFromParent()
			}
		}

		if !gameOver {
			score += 1
		}
	}

	func createEnemy() {
		possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(possibleEnemies) as! [String]
		let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 736)

		let sprite = SKSpriteNode(imageNamed: possibleEnemies[0])
		sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
		addChild(sprite)

		sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
		sprite.physicsBody?.categoryBitMask = 1
		sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
		sprite.physicsBody?.angularVelocity = 5
		sprite.physicsBody?.linearDamping = 0
		sprite.physicsBody?.angularDamping = 0
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard let touch = touches.first else { return }
		var location = touch.locationInNode(self)

		if location.y < 100 {
			location.y = 100
		} else if location.y > 668 {
			location.y = 668
		}

		player.position = location
	}

	func didBeginContact(contact: SKPhysicsContact) {
		let explosion = SKEmitterNode(fileNamed: "explosion")!
		explosion.position = player.position
		addChild(explosion)

		player.removeFromParent()

		gameOver = true
	}
}
