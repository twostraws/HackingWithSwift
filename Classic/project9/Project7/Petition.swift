//
//  Petition.swift
//  Project7
//
//  Created by Paul Hudson on 23/10/2018.
//  Copyright © 2018 Paul Hudson. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
