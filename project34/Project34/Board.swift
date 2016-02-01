//
//  Board.swift
//  Project34
//
//  Created by Hudzilla on 19/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import UIKit

enum ChipColor: Int {
	case None = 0
	case Red
	case Black
}

class Board: NSObject, GKGameModel {
	static var width = 7
	static var height = 6

	var slots = [ChipColor]()
	var currentPlayer: Player

	var players: [GKGameModelPlayer]? {
		return Player.allPlayers
	}

	var activePlayer: GKGameModelPlayer? {
		return currentPlayer
	}

	override init() {
		currentPlayer = Player.allPlayers[0]

		for _ in 0 ..< Board.width * Board.height {
			slots.append(.None)
		}

		super.init()
	}

	func chipInColumn(column: Int, row: Int) -> ChipColor {
		return slots[row + column * Board.height]
	}

	func setChip(chip: ChipColor, inColumn column: NSInteger, row: NSInteger) {
		slots[row + column * Board.height] = chip;
	}

	func squaresMatchChip(chip: ChipColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
		// bail out early if we can't win from here
		if row + (moveY * 3) < 0 { return false }
		if row + (moveY * 3) >= Board.height { return false }
		if col + (moveX * 3) < 0 { return false }
		if col + (moveX * 3) >= Board.width { return false }

		// still here? Check every square
		if chipInColumn(col, row: row) != chip { return false }
		if chipInColumn(col + moveX, row: row + moveY) != chip { return false }
		if chipInColumn(col + (moveX * 2), row: row + (moveY * 2)) != chip { return false }
		if chipInColumn(col + (moveX * 3), row: row + (moveY * 3)) != chip { return false }

		return true
	}

	func nextEmptySlotInColumn(column: Int) -> Int? {
		for row in 0 ..< Board.height {
			if chipInColumn(column, row: row) == .None {
				return row
			}
		}

		return nil;
	}

	func canMoveInColumn(column: Int) -> Bool {
		return nextEmptySlotInColumn(column) != nil
	}

	func addChip(chip: ChipColor, inColumn column: Int) {
		if let row = nextEmptySlotInColumn(column) {
			setChip(chip, inColumn:column, row:row)
		}
	}

	func isFull() -> Bool {
		for column in 0 ..< Board.width {
			if canMoveInColumn(column) {
				return false
			}
		}

		return true;
	}

	func isWinForPlayer(player: GKGameModelPlayer) -> Bool {
		let chip = (player as! Player).chip

		for row in 0 ..< Board.height {
			for col in 0 ..< Board.width {
				if squaresMatchChip(chip, row: row, col: col, moveX: 1, moveY: 0) {
					return true
				} else if squaresMatchChip(chip, row: row, col: col, moveX: 0, moveY: 1) {
					return true
				} else if squaresMatchChip(chip, row: row, col: col, moveX: 1, moveY: 1) {
					return true
				} else if squaresMatchChip(chip, row: row, col: col, moveX: 1, moveY: -1) {
					return true
				}
			}
		}

		return false
	}

	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = Board()
		copy.setGameModel(self)
		return copy
	}

	func setGameModel(gameModel: GKGameModel) {
		if let board = gameModel as? Board {
			slots = board.slots
			currentPlayer = board.currentPlayer
		}
	}

	func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
		// 1
		if let playerObject = player as? Player {
			// 2
			if isWinForPlayer(playerObject) || isWinForPlayer(playerObject.opponent) {
				return nil
			}

			// 3
			var moves = [Move]()

			// 4
			for column in 0 ..< Board.width {
				if canMoveInColumn(column) {
					// 5
					moves.append(Move(column: column))
				}
			}

			// 6
			return moves;
		}

		return nil
	}

	func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
		if let move = gameModelUpdate as? Move {
			addChip(currentPlayer.chip, inColumn: move.column)
			currentPlayer = currentPlayer.opponent
		}
	}

	func scoreForPlayer(player: GKGameModelPlayer) -> Int {
		if let playerObject = player as? Player {
			if isWinForPlayer(playerObject) {
				return 1000
			} else if isWinForPlayer(playerObject.opponent) {
				return -1000
			}
		}

		return 0
	}
}
