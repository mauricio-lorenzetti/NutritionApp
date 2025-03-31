//
//  TabItem.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

enum TabItem: Int, CaseIterable {
    case home, logs, scan, streaks, profile

    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .logs:
            return "bookmark.fill"
        case .scan:
            return "viewfinder"
        case .streaks:
            return "flame.fill"
        case .profile:
            return "person.fill"
        }
    }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .logs:
            return "Logs"
        case .scan:
            return ""
        case .streaks:
            return "Streaks"
        case .profile:
            return "Profile"
        }
    }
}
