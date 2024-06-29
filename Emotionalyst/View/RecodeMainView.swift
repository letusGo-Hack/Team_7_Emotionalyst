//
//  EmotionalystView.swift
//  Emotionalyst
//
//  Created by Hosung Lim on 6/29/24.
//

import SwiftUI
import SwiftData

struct EmotionalystView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        RecordingView()
            .tabItem {
                Image(systemName: "waveform")
                Text("recording")
            }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    EmotionalystView()
        .modelContainer(for: Item.self, inMemory: true)
}


//List {
//    ForEach(items) { item in
//        NavigationLink {
//            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//        } label: {
//            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//        }
//    }
//    .onDelete(perform: deleteItems)
//}
//.toolbar {
//    ToolbarItem(placement: .navigationBarTrailing) {
//        EditButton()
//    }
//    ToolbarItem {
//        Button(action: addItem) {
//            Label("Add Item", systemImage: "plus")
//        }
//    }
//}
