//
//  EmotionalystApp.swift
//  Emotionalyst
//
//  Created by Hosung Lim on 6/29/24.
//

import SwiftUI
import SwiftData

@main
struct EmotionalystApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AudioItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            EmotionalystView()
        }
        .modelContainer(sharedModelContainer)
    }
}
