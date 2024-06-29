//
//  RecordingButton.swift
//  Emotionalyst
//
//  Created by 신의연 on 6/29/24.
//

import SwiftUI
import AVFoundation

struct RecordingButton: View {
    let action: (() -> Void)
    @State var isPressed: Bool = false
    
    var body: some View {
        VStack {
            Button {
                self.isPressed = !isPressed
                action()
            } label: {
                if isPressed {
                    Image(systemName: "stop.circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .gray)
                        .font(.system(size: 50))
                } else {
                    Image(systemName: "record.circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .gray)
                        .font(.system(size: 50))
                }
            }
        }
    }
}

func requestRecordPermission() {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
        if granted {
            // Permission granted
        } else {
            // Handle permission denied
        }
    }
}

#Preview {
    
    VStack {
        RecordingButton {
            print("pressed")
        }
    }
}
