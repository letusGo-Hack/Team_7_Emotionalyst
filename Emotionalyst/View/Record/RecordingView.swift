//
//  RecordingView.swift
//  Emotionalyst
//
//  Created by 신의연 on 6/29/24.
//

import SwiftUI

struct RecordingView: View {
    
    @StateObject private var audioRecoder = AudioRecorder()
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                WaveBar(isPlay: true, high: 1)
                WaveBar(isPlay: true, high: 2)
                WaveBar(isPlay: true, high: 1)
                WaveBar(isPlay: true, high: 4)
                WaveBar(isPlay: true, high: 3)
                WaveBar(isPlay: true, high: 1)
                WaveBar(isPlay: true, high: 2)
                WaveBar(isPlay: true, high: 3)
            }
            Spacer()
            RecordingButton {
                
            }
        }
        .padding(10)
    }
}

#Preview {
    RecordingView()
}
