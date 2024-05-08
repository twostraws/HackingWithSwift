//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Paul Hudson on 08/05/2024.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
