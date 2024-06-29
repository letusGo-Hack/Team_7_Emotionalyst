//
//  WaveBar.swift
//  Emotionalyst
//
//  Created by 신의연 on 6/29/24.
//

import SwiftUI

struct WaveBar: View {
    @State var isPlay: Bool
    var low: CGFloat = 1.0
    var high: CGFloat = 1.0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(.indigo.gradient)
            .frame(height: (isPlay ? high : low) * 64)
            .frame(height: 64, alignment: .bottom)
            .animation(.linear(duration: 5).repeatForever(), value: isPlay)
    }
}

#Preview {
    HStack {
        WaveBar(isPlay: false, high: 2)
        
        WaveBar(isPlay: true, high: 1)
        
        WaveBar(isPlay: true, high: 3)
        
        WaveBar(isPlay: true, high: 4)
    }
}
