//
//  Move.swift
//  Project34
//
//  Created by Hudzilla on 19/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
	var value: Int = 0
	var column: Int

	init(column: Int) {
		self.column = column
	}
}