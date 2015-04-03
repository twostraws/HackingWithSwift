//
//  GameScene.swift
//  Project14
//
//  Created by Hudzilla on 22/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//
//  The image whackBackground.png and whackBackground@2x.png were
//  based upon vector artwork created by FreeVectorStock.com under
//  the following licence:
//
//  This vector art is under the Attribution Creative Commons 3.0 license 
//  (http://creativecommons.org/about/licenses/)
//  That means YOU MUST GIVE ATTRIBUTION to Vector Open Stock for this artwork
//  either if you use it in your designs or you republish in a website. Please
//  add a DO FOLLOW LINK TO:
//
//	Text: Vector Open Stock
//	URL: www.vectoropenstock.com
//
//	This license lets others distribute, remix, tweak, and build upon your work,
//  even commercially, as long as they credit you for the original creation.
//  This is the most accommodating of licenses offered, in terms of what others
//  can do with your works licensed under Attribution.

import SpriteKit

class GameScene: SKScene {
	var slots = [WhackSlot]()

	var popupTime = 0.85
	var numRounds = 0

	var gameScore: SKLabelNode!
	var score: Int = 0 {
		didSet {
			gameScore.text = "Score: \(score)"
		}
	}

    override func didMoveToView(view: SKView) {
		let background = SKSpriteNode(imageNamed: "whackBackground")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		addChild(background)

		gameScore = SKLabelNode(fontNamed: "Chalkduster")
		gameScore.text = "Score: 0"
		gameScore.position = CGPoint(x: 8, y: 8)
		gameScore.horizontalAlignmentMode = .Left
		gameScore.fontSize = 48
		addChild(gameScore)

		for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 410)) }
		for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 320)) }
		for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 230)) }
		for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 140)) }

		runAfterDelay(1) { [unowned self] in
			self.createEnemy()
		}
	}

	func createSlotAt(pos: CGPoint) {
		let slot = WhackSlot()
		slot.configureAtPosition(pos)
		addChild(slot)
		slots.append(slot)
	}

	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		let touch = touches.anyObject() as UITouch

		let location = touch.locationInNode(self)
		let nodes = nodesAtPoint(location) as [SKNode]

		for node in nodes {
			if node.name == "charFriend" {
				// they shouldn't have whacked this penguin
				let whackSlot = node.parent!.parent as WhackSlot
				if !whackSlot.visible { continue }
				if whackSlot.isHit { continue }

				whackSlot.hit()
				score -= 5

				runAction(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
			} else if node.name == "charEnemy" {
				// they should have whacked this one
				let whackSlot = node.parent!.parent as WhackSlot
				if !whackSlot.visible { continue }
				if whackSlot.isHit { continue }

				whackSlot.charNode.xScale = 0.85
				whackSlot.charNode.yScale = 0.85

				whackSlot.hit()
				++score

				runAction(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
			}
		}
	}

	func createEnemy() {
		popupTime *= 0.991
		++numRounds

		if numRounds >= 30 {
			for slot in slots {
				slot.hide()
			}

			let gameOver = SKSpriteNode(imageNamed: "gameOver")
			gameOver.position = CGPoint(x: 512, y: 384)
			addChild(gameOver)
			
			return
		}

		slots.shuffle()
		slots[0].show(hideTime: popupTime)

		if RandomInt(min: 0, max: 12) > 5 { slots[1].show(hideTime: popupTime) }
		if RandomInt(min: 0, max: 12) > 8 {	slots[2].show(hideTime: popupTime) }
		if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
		if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime)	}

		let minDelay = popupTime / 2.0
		let maxDelay = popupTime * 2

		runAfterDelay(RandomDouble(min: minDelay, max: maxDelay)) { [unowned self] in
			self.createEnemy()
		}
	}
}
