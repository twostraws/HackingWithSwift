//
//  Move.swift
//  Project34
//
//  Created by TwoStraws on 25/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
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
