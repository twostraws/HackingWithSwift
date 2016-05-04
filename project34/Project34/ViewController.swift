//
//  ViewController.swift
//  Project34
//
//  Created by Hudzilla on 19/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import UIKit

class ViewController: UIViewController {
	@IBOutlet var columnButtons: [UIButton]!

	var placedChips = [[UIView]]()
	var board: Board!

	var strategist: GKMinmaxStrategist!

	override func viewDidLoad() {
		super.viewDidLoad()

		for _ in 0 ..< Board.width {
			placedChips.append([UIView]())
		}

		strategist = GKMinmaxStrategist()
		strategist.maxLookAheadDepth = 7
		strategist.randomSource = nil

		resetBoard()
	}

	func resetBoard() {
		board = Board()
		strategist.gameModel = board
		updateUI()

		for i in 0 ..< placedChips.count {
			for chip in placedChips[i] {
				chip.removeFromSuperview()
			}

			placedChips[i].removeAll(keepCapacity: true)
		}
	}

	@IBAction func makeMove(sender: UIButton) {
		let column = sender.tag

		if let row = board.nextEmptySlotInColumn(column) {
			board.addChip(board.currentPlayer.chip, inColumn: column)
			addChipAtColumn(column, row: row, color: board.currentPlayer.color)
			continueGame()
		}
	}

	func addChipAtColumn(column: Int, row: Int, color: UIColor) {
		let button = columnButtons[column]
		let size = min(button.frame.width, button.frame.height / 6)
		let rect = CGRect(x: 0, y: 0, width: size, height: size)

		if (placedChips[column].count < row + 1) {
			let newChip = UIView()
			newChip.frame = rect
			newChip.userInteractionEnabled = false
			newChip.backgroundColor = color
			newChip.layer.cornerRadius = size / 2
			newChip.center = positionForChipAtColumn(column, row: row)
			newChip.transform = CGAffineTransformMakeTranslation(0, -800)
			view.addSubview(newChip)

			UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
				newChip.transform = CGAffineTransformIdentity
				}, completion: nil)

			placedChips[column].append(newChip)
		}
	}

	func positionForChipAtColumn(column: Int, row: Int) -> CGPoint {
		let button = columnButtons[column]
		let size = min(button.frame.width, button.frame.height / 6)

		let xOffset = button.frame.midX
		var yOffset = button.frame.maxY - size / 2
		yOffset -= size * CGFloat(row)
		return CGPoint(x: xOffset, y: yOffset)
	}

	func updateUI() {
		title = "\(board.currentPlayer.name)'s Turn"

		if board.currentPlayer.chip == .Black {
			startAIMove()
		}
	}

	func continueGame() {
		// 1
		var gameOverTitle: String? = nil

		// 2
		if board.isWinForPlayer(board.currentPlayer) {
			gameOverTitle = "\(board.currentPlayer.name) Wins!"
		} else if board.isFull() {
			gameOverTitle = "Draw!"
		}

		// 3
		if gameOverTitle != nil {
			let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .Alert)
			let alertAction = UIAlertAction(title: "Play Again", style: .Default) { [unowned self] (action) in
				self.resetBoard()
			}

			alert.addAction(alertAction)
			presentViewController(alert, animated: true, completion: nil)

			return
		}

		// 4
		board.currentPlayer = board.currentPlayer.opponent
		updateUI()
	}

	func columnForAIMove() -> Int? {
		if let aiMove = strategist.bestMoveForPlayer(board.currentPlayer) as? Move {
			return aiMove.column
		}

		return nil
	}

	func makeAIMoveInColumn(column: Int) {
		columnButtons.forEach { $0.enabled = true }
		navigationItem.leftBarButtonItem = nil

		if let row = board.nextEmptySlotInColumn(column) {
			board.addChip(board.currentPlayer.chip, inColumn: column)
			addChipAtColumn(column, row:row, color: board.currentPlayer.color)

			continueGame()
		}
	}

	func startAIMove() {
		columnButtons.forEach { $0.enabled = false }

		let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		spinner.startAnimating()

		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [unowned self] in
			let strategistTime = CFAbsoluteTimeGetCurrent()
			let column = self.columnForAIMove()!
			let delta = CFAbsoluteTimeGetCurrent() - strategistTime

			let aiTimeCeiling = 1.0
			let delay = min(aiTimeCeiling - delta, aiTimeCeiling)

			self.runAfterDelay(delay) {
				self.makeAIMoveInColumn(column)
			}
		}
	}

	func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
		dispatch_after(time, dispatch_get_main_queue(), block)
	}
}

