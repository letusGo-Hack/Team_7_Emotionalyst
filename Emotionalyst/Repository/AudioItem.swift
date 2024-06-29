//
//  EmotionAudio.swift
//  Emotionalyst
//
//  Created by 김상진 on 6/29/24.
//

import Foundation
import SwiftData

@Model
class AudioItem {
    var url: URL
    var timestamp: Date
    var emotion: Emotion
    
    init(url: URL, timestamp: Date, emotion: Emotion) {
        self.url = url
        self.timestamp = timestamp
        self.emotion = emotion
    }
}

