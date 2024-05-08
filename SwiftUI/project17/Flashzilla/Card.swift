//
//  Card.swift
//  Flashzilla
//
//  Created by Paul Hudson on 08/05/2024.
//

import Foundation

struct Card: Codable {
    var prompt: String
    var answer: String

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
