//
//  Whistle.swift
//  Project33
//
//  Created by Hudzilla on 19/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import CloudKit
import UIKit

class Whistle: NSObject {
	var recordID: CKRecordID!
	var genre: String!
	var comments: String!
	var audio: NSURL!
}