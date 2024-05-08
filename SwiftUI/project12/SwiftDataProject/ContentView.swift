//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Paul Hudson on 08/05/2024.
//

import SwiftData
import SwiftUI

//struct ContentView: View {
//    @Environment(\.modelContext) var modelContext
//    @Query(sort: \User.name) var users: [User]
//    @State private var path = [User]()
//
//    var body: some View {
//        NavigationStack(path: $path) {
//            List(users) { user in
//                NavigationLink(value: user) {
//                    Text(user.name)
//                }
//            }
//            .navigationTitle("Users")
//            .navigationDestination(for: User.self) { user in
//                EditUserView(user: user)
//            }
//            .toolbar {
//                Button("Add User", systemImage: "plus") {
//                    let user = User(name: "", city: "", joinDate: .now)
//                    modelContext.insert(user)
//                    path = [user]
//                }
//            }
//        }
//    }
//}

//struct ContentView: View {
//    @Environment(\.modelContext) var modelContext
//    
//    @Query(filter: #Predicate<User> { user in
//        user.name.localizedStandardContains("R") &&
//        user.city == "London"
//    }, sort: \User.name) var users: [User]
//
//    var body: some View {
//        NavigationStack {
//            List(users) { user in
//                Text(user.name)
//            }
//            .navigationTitle("Users")
//            .toolbar {
//                Button("Add Samples", systemImage: "plus") {
//                    try? modelContext.delete(model: User.self)
//
//                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
//                    let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
//                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
//                    let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
//
//                    modelContext.insert(first)
//                    modelContext.insert(second)
//                    modelContext.insert(third)
//                    modelContext.insert(fourth)
//                }
//            }
//        }
//    }
//}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    @State private var showingUpcomingOnly = false

    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]

    @Query(filter: #Predicate<User> { user in
        user.name.localizedStandardContains("R") &&
        user.city == "London"
    }, sort: \User.name) var users: [User]

    var body: some View {
        NavigationStack {
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
                .navigationTitle("Users")
                .toolbar {
                    Button("Add Samples 1", systemImage: "plus", action: addSamples1)

                    Button("Add Samples 1", systemImage: "plus", action: addSamples2)

                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by Name")
                                .tag([
                                    SortDescriptor(\User.name),
                                    SortDescriptor(\User.joinDate),
                                ])
                            
                            Text("Sort by Join Date")
                                .tag([
                                    SortDescriptor(\User.joinDate),
                                    SortDescriptor(\User.name)
                                ])
                        }
                    }
                }
        }
    }

    func addSamples1() {
        try? modelContext.delete(model: User.self)

        let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
        let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
        let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
        let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))

        modelContext.insert(first)
        modelContext.insert(second)
        modelContext.insert(third)
        modelContext.insert(fourth)
    }

    func addSamples2() {
        let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Organize sock drawer", priority: 3)
        let job2 = Job(name: "Make plans with Alex", priority: 4)

        modelContext.insert(user1)

        user1.jobs?.append(job1)
        user1.jobs?.append(job2)
    }
}

#Preview {
    ContentView()
}
