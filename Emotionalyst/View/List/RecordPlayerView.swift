//
//  RecordPlayerView.swift
//  Emotionalyst
//
//  Created by 신의연 on 6/29/24.
//

import SwiftUI
import AVFoundation

struct RecordPlayerView: View {
    @State var audioData: AudioListData
    //@StateObject private var audioEngine: Audio = Audio(URL(string: "")!) // 고도화 때 에러처리 합시다 ㅠㅠ
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(audioData.timeStamp)
                    Spacer()
                    Text(audioData.emotion.rawValue)
                }
            }
            .padding()
            .background(Color.white)
            .onTapGesture {
                self.audioData.isTouched.toggle()
            }
            
            if audioData.isTouched {
                Text("Hi")
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 2)
                        .padding(.all, 10)
                    
                    Button {
                        print("play")
                    } label: {
                        Image(systemName: "play.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.black)
                            .font(.system(size: 50))
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerSize: CGSize(
                    width: 10,
                    height: 10
                )
            )
        )
    }
}

#Preview {
    VStack {
        Spacer()
        RecordPlayerView(
            audioData: AudioListData(
                timeStamp: "sample",
                url: nil,
                emotion: .angry,
                isTouched: false
            )
        )
        Spacer()
    }
    .padding()
    .background(Color.gray)
}
