//
//  GameScene.swift
//  Project17
//
//  Created by TwoStraws on 18/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import AVFoundation
import SpriteKit

enum ForceBomb {
	case never, always, random
}

enum SequenceType: CaseIterable {
	case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
	var gameScore: SKLabelNode!
	var score = 0 {
		didSet {
			gameScore.text = "Score: \(score)"
		}
	}

	var livesImages = [SKSpriteNode]()
	var lives = 3

	var activeSliceBG: SKShapeNode!
	var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()

    var activeEnemies = [SKSpriteNode]()
    var isSwooshSoundActive = false
	var bombSoundEffect: AVAudioPlayer!

	var popupTime = 0.9
	var sequence: [SequenceType]!
	var sequencePosition = 0
	var chainDelay = 3.0
	var nextSequenceQueued = true

    var gameEnded = false

    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "sliceBackground")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)

		physicsWorld.gravity = CGVector(dx: 0, dy: -6)
		physicsWorld.speed = 0.85

		createScore()
		createLives()
		createSlices()

		sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]

		for _ in 0 ... 1000 {
			let nextSequence = SequenceType.allCases.randomElement()!
			sequence.append(nextSequence)
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
			self.tossEnemies()
		}
    }

	func createScore() {
		gameScore = SKLabelNode(fontNamed: "Chalkduster")
		gameScore.text = "Score: 0"
		gameScore.horizontalAlignmentMode = .left
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

		activeSliceFG.strokeColor = UIColor.white
		activeSliceFG.lineWidth = 5

		addChild(activeSliceBG)
		addChild(activeSliceFG)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)

		// 1
		activeSlicePoints.removeAll(keepingCapacity: true)

		// 2
		if let touch = touches.first {
			let location = touch.location(in: self)
			activeSlicePoints.append(location)

			// 3
			redrawActiveSlice()

			// 4
			activeSliceBG.removeAllActions()
			activeSliceFG.removeAllActions()

			// 5
			activeSliceBG.alpha = 1
			activeSliceFG.alpha = 1
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if gameEnded {
			return
		}

		guard let touch = touches.first else { return }

		let location = touch.location(in: self)

		activeSlicePoints.append(location)
		redrawActiveSlice()

		if !isSwooshSoundActive {
			playSwooshSound()
		}

		let nodesAtPoint = nodes(at: location)

		for node in nodesAtPoint {
			if node.name == "enemy" {
				// destroy penguin
				// 1
				let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy")!
				emitter.position = node.position
				addChild(emitter)

				// 2
				node.name = ""

				// 3
				node.physicsBody?.isDynamic = false

				// 4
				let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
				let fadeOut = SKAction.fadeOut(withDuration: 0.2)
				let group = SKAction.group([scaleOut, fadeOut])

				// 5
				let seq = SKAction.sequence([group, SKAction.removeFromParent()])
				node.run(seq)

				// 6
				score += 1

				// 7
				let index = activeEnemies.index(of: node as! SKSpriteNode)!
				activeEnemies.remove(at: index)

				// 8
				run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
			} else if node.name == "bomb" {
				// destroy bomb
				let emitter = SKEmitterNode(fileNamed: "sliceHitBomb")!
				emitter.position = node.parent!.position
				addChild(emitter)

				node.name = ""
				node.parent?.physicsBody?.isDynamic = false

				let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
				let fadeOut = SKAction.fadeOut(withDuration: 0.2)
				let group = SKAction.group([scaleOut, fadeOut])

				let seq = SKAction.sequence([group, SKAction.removeFromParent()])

				node.parent?.run(seq)

				let index = activeEnemies.index(of: node.parent as! SKSpriteNode)!
				activeEnemies.remove(at: index)

				run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
				endGame(triggeredByBomb: true)
			}
		}
	}

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
		activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
	}

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
	}

	func redrawActiveSlice() {
		// 1
		if activeSlicePoints.count < 2 {
			activeSliceBG.path = nil
			activeSliceFG.path = nil
			return
		}

		// 2
		while activeSlicePoints.count > 12 {
			activeSlicePoints.remove(at: 0)
		}

		// 3
		let path = UIBezierPath()
		path.move(to: activeSlicePoints[0])

		for i in 1 ..< activeSlicePoints.count {
			path.addLine(to: activeSlicePoints[i])
		}

		// 4
		activeSliceBG.path = path.cgPath
		activeSliceFG.path = path.cgPath
	}

	func playSwooshSound() {
		isSwooshSoundActive = true

        let randomNumber = Int.random(in: 1...3)
		let soundName = "swoosh\(randomNumber).caf"

		let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)

		run(swooshSound) { [unowned self] in
			self.isSwooshSoundActive = false
		}
	}

	func createEnemy(forceBomb: ForceBomb = .random) {
		var enemy: SKSpriteNode

        var enemyType = Int.random(in: 0...6)

		if forceBomb == .never {
			enemyType = 1
		} else if forceBomb == .always {
			enemyType = 0
		}

		if enemyType == 0 {
			// 1
			enemy = SKSpriteNode()
			enemy.zPosition = 1
			enemy.name = "bombContainer"

			// 2
			let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
			bombImage.name = "bomb"
			enemy.addChild(bombImage)

			// 3
			if bombSoundEffect != nil {
				bombSoundEffect.stop()
				bombSoundEffect = nil
			}

			// 4
			let path = Bundle.main.path(forResource: "sliceBombFuse.caf", ofType:nil)!
			let url = URL(fileURLWithPath: path)
			let sound = try! AVAudioPlayer(contentsOf: url)
			bombSoundEffect = sound
			sound.play()

			// 5
			let emitter = SKEmitterNode(fileNamed: "sliceFuse")!
			emitter.position = CGPoint(x: 76, y: 64)
			enemy.addChild(emitter)
		} else {
			enemy = SKSpriteNode(imageNamed: "penguin")
			run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
			enemy.name = "enemy"
		}

		// 1
		let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
		enemy.position = randomPosition

		// 2
        let randomAngularVelocity = CGFloat.random(in: -6...6) / 2.0
		var randomXVelocity = 0

		// 3
		if randomPosition.x < 256 {
			randomXVelocity = Int.random(in: 8...15)
		} else if randomPosition.x < 512 {
			randomXVelocity = Int.random(in: 3...5)
		} else if randomPosition.x < 768 {
			randomXVelocity = -Int.random(in: 3...5)
		} else {
			randomXVelocity = -Int.random(in: 8...15)
		}

		// 4
		let randomYVelocity = Int.random(in: 24...32)

		// 5
		enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
		enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
		enemy.physicsBody?.angularVelocity = randomAngularVelocity
		enemy.physicsBody?.collisionBitMask = 0

		addChild(enemy)
		activeEnemies.append(enemy)
	}

	override func update(_ currentTime: TimeInterval) {
		if activeEnemies.count > 0 {
			for node in activeEnemies {
				if node.position.y < -140 {
					node.removeAllActions()

					if node.name == "enemy" {
						node.name = ""
						subtractLife()

						node.removeFromParent()

						if let index = activeEnemies.index(of: node) {
							activeEnemies.remove(at: index)
						}
					} else if node.name == "bombContainer" {
						node.name = ""
						node.removeFromParent()

						if let index = activeEnemies.index(of: node) {
							activeEnemies.remove(at: index)
						}
					}
				}
			}
		} else {
			if !nextSequenceQueued {
				DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [unowned self] in
					self.tossEnemies()
				}

				nextSequenceQueued = true
			}
		}

		var bombCount = 0

		for node in activeEnemies {
			if node.name == "bombContainer" {
				bombCount += 1
				break
			}
		}

		if bombCount == 0 {
			// no bombs – stop the fuse sound!
			if bombSoundEffect != nil {
				bombSoundEffect.stop()
				bombSoundEffect = nil
			}
		}
	}

	func tossEnemies() {
		if gameEnded {
			return
		}

		popupTime *= 0.991
		chainDelay *= 0.99
		physicsWorld.speed *= 1.02

		let sequenceType = sequence[sequencePosition]

		switch sequenceType {
		case .oneNoBomb:
			createEnemy(forceBomb: .never)

		case .one:
			createEnemy()

		case .twoWithOneBomb:
			createEnemy(forceBomb: .never)
			createEnemy(forceBomb: .always)

		case .two:
			createEnemy()
			createEnemy()

		case .three:
			createEnemy()
			createEnemy()
			createEnemy()

		case .four:
			createEnemy()
			createEnemy()
			createEnemy()
			createEnemy()

		case .chain:
			createEnemy()

			DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [unowned self] in self.createEnemy() }
			DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [unowned self] in self.createEnemy() }
			DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [unowned self] in self.createEnemy() }
			DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [unowned self] in self.createEnemy() }

		case .fastChain:
			createEnemy()

			DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [unowned self] in self.createEnemy() }
			DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [unowned self] in self.createEnemy() }
			DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [unowned self] in self.createEnemy() }
			DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [unowned self] in self.createEnemy() }
		}


		sequencePosition += 1
		nextSequenceQueued = false
	}

	func subtractLife() {
		lives -= 1

		run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))

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
		life.run(SKAction.scale(to: 1, duration:0.1))
	}

	func endGame(triggeredByBomb: Bool) {
		if gameEnded {
			return
		}

		gameEnded = true
		physicsWorld.speed = 0
		isUserInteractionEnabled = false

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
