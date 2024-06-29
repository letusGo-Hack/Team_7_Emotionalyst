//
//  RecordingView.swift
//  Emotionalyst
//
//  Created by 신의연 on 6/29/24.
//

import SwiftUI

struct RecordingView: View {
    
    @StateObject private var audioRecoder = AudioRecorder()
    var coreEngine = CoreEngine()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                WaveBar(isPlay: true, high: CGFloat(coreEngine.rmsData / 0.7))
                WaveBar(isPlay: true, high: CGFloat(coreEngine.rmsData) / 0.3)
                WaveBar(isPlay: true, high: CGFloat(coreEngine.rmsData) / 0.5)
                WaveBar(isPlay: true, high: CGFloat(coreEngine.rmsData) / 0.1)
                WaveBar(isPlay: true, high: CGFloat(coreEngine.rmsData) / 0.2)
                WaveBar(isPlay: true, high: CGFloat(coreEngine.rmsData) / 0.9)
                WaveBar(isPlay: true, high: CGFloat(coreEngine.rmsData) / 0.7)

            }
            Spacer()
            RecordingButton {
                coreEngine.startAudioEngine()
            }
        }
        .padding(10)
    }
}

#Preview {
    RecordingView()
}
