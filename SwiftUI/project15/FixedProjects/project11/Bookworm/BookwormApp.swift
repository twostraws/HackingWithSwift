//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Paul Hudson on 16/11/2023.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
