//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Paul Hudson on 08/05/2024.
//

import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
