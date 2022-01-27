//
//  Resort.swift
//  SnowSeeker
//
//  Created by Paul Hudson on 23/01/2022.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]

    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }

    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}
