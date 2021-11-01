//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Paul Hudson on 01/11/2021.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
