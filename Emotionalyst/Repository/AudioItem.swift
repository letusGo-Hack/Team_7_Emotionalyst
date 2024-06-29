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
    var urlString: String
    var timestamp: Date
    var emotion: Emotion
    
    init(urlString: String, timestamp: Date, emotion: Emotion) {
        self.urlString = urlString
        self.timestamp = timestamp
        self.emotion = emotion
    }
}

