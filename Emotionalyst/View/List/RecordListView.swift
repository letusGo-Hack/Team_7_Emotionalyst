//
//  RecordListView.swift
//  Emotionalyst
//
//  Created by 신의연 on 6/29/24.
//

import SwiftUI

//MARK: - mock 데이터는 샘플
struct RecordListView: View {
    
    let mockData: [AudioMetaData] = [
        AudioMetaData(
            timeStamp: "2024-06-29 14:51",
            url: URL(string: "sample"),
            emotion: .happy
        ),
        AudioMetaData(
            timeStamp: "2024-06-30 17:51",
            url: URL(string: "sample"),
            emotion: .angry
        ),
        AudioMetaData(
            timeStamp: "2024-07-01 14:51",
            url: URL(string: "sample"),
            emotion: .sad
        ),
        AudioMetaData(
            timeStamp: "2024-06-29 14:10",
            url: URL(string: "sample"),
            emotion: .happy
        )
    ]
        .sorted { lhs, rhs in
            return lhs.timeStamp > rhs.timeStamp
        }
    
    var body: some View {
        List(mockData) { audioData in
            VStack {
                RecordPlayerView(audioData: AudioListData.convert2AudioListData(audioMetaData: audioData))
                Divider()
            }
            .listRowSeparator(.hidden)
            .buttonStyle(BorderlessButtonStyle())
        }
        
    }
}

#Preview {
    RecordListView()
}

enum Emotion: String, Equatable, Codable {
    case happy = "happy"
    case sad = "sad"
    case angry = "angry"
}

struct AudioMetaData: Hashable, Codable, Identifiable {
    var id: UUID
    var timeStamp: String
    var url: URL?
    var emotion: Emotion
    
    init(timeStamp: String, url: URL? = nil, emotion: Emotion) {
        self.id = UUID()
        self.timeStamp = timeStamp
        self.url = url
        self.emotion = emotion
    }
}

struct AudioListData: Hashable, Codable, Identifiable {
    var id: UUID
    var timeStamp: String
    var url: URL?
    var emotion: Emotion
    var isTouched: Bool
    
    init(timeStamp: String, url: URL? = nil, emotion: Emotion, isTouched: Bool = false) {
        self.id = UUID()
        self.timeStamp = timeStamp
        self.url = url
        self.emotion = emotion
        self.isTouched = false
    }
    
    static func convert2AudioListData(audioMetaData: AudioMetaData) -> AudioListData {
        return AudioListData(
            timeStamp: audioMetaData.timeStamp,
            url: audioMetaData.url,
            emotion: audioMetaData.emotion
        )
    }
}
