//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Paul Hudson on 08/05/2024.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    @Query var users: [User]

    var body: some View {
        List(users) { user in
            HStack {
                Text(user.name)

                Spacer()

                Text(String(user.unwrappedJobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
    }

    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
