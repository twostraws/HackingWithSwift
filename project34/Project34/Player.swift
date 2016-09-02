//
//  Player.swift
//  Project34
//
//  Created by TwoStraws on 25/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import GameplayKit
import UIKit

class Player: NSObject, GKGameModelPlayer {
	var chip: ChipColor
	var color: UIColor
	var name: String
	var playerId: Int

	static var allPlayers = [Player(chip: .red), Player(chip: .black)]

	var opponent: Player {
		if chip == .red {
			return Player.allPlayers[1]
		} else {
			return Player.allPlayers[0]
		}
	}

	init(chip: ChipColor) {
		self.chip = chip
		self.playerId = chip.rawValue

		if chip == .red {
			color = .red
			name = "Red"
		} else {
			color = .black
			name = "Black"
		}

		super.init()
	}
}
