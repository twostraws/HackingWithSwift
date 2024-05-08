//
//  Location.swift
//  BucketList
//
//  Created by Paul Hudson on 08/05/2024.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Lit by over 40,000 lightbulbs.", latitude: 51.501, longitude: -0.141)

    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
