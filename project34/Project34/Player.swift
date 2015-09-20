//
//  Player.swift
//  Project34
//
//  Created by Hudzilla on 19/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import UIKit

class Player: NSObject, GKGameModelPlayer {
	var chip: ChipColor
	var color: UIColor
	var name: String
	var playerId: Int

	static var allPlayers = [Player(chip: .Red), Player(chip: .Black)]

	init(chip: ChipColor) {
		self.chip = chip
		self.playerId = chip.rawValue

		if chip == .Red {
			color = .redColor()
			name = "Red"
		} else {
			color = .blackColor()
			name = "Black"
		}

		super.init()
	}

	var opponent: Player {
		if chip == .Red {
			return Player.allPlayers[1]
		} else {
			return Player.allPlayers[0]
		}
	}
}
