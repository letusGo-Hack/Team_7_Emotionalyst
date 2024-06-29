//
//  SwiftDataTestView.swift
//  Emotionalyst
//
//  Created by 김상진 on 6/29/24.
//

import SwiftUI
import SwiftData

struct SwiftDataTestView: View {
    @Environment(\.modelContext) var context
    
    @Query var items: [AudioItem]
    
    @State private var count: Int = 0
    
    var body: some View {
        
        Button {
            let item = AudioItem(urlString: "\(count)",
                                 timestamp: Date(),
                                 emotion: .happy)
            context.insert(item)
            count += 1
        } label: {
            Text("추가")
        }

        List {
            ForEach(items) { item in
                Text("\(item.urlString), \(item.timestamp), \(item.emotion)")
            }
        }
        
    }
}

#Preview {
    SwiftDataTestView()
}
