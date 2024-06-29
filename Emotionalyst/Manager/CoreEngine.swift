//
//  CoreEngine.swift
//  Emotionalyst
//
//  Created by lukaOS on 6/29/24.
//


import AVFoundation
import CoreML

class CoreEngine: NSObject, AVAudioRecorderDelegate, ObservableObject{
    
    var audioEngine: AVAudioEngine!
    var inputNode: AVAudioInputNode!
    var model: Emotion_Analstics_Gish?
    
    override init() {
        super.init()
        self.audioEngine = AVAudioEngine()
        self.inputNode = audioEngine.inputNode
        do{
            self.model = try Emotion_Analstics_Gish(configuration: MLModelConfiguration())
        }catch{
            print("Error initializing model : \(error.localizedDescription)")
        }
    }
    
    func startAudioEngine(){
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.analyzeAudio(buffer: buffer)
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            print("AudioEngine start error: \(error.localizedDescription)")
        }
    }
    
    private func analyzeAudio(buffer: AVAudioPCMBuffer){
        guard let model = model else {
            print("Model is not initialized")
            return
        }
        
        guard let channelData = buffer.floatChannelData?[0] else { return }

        let frameLength = Int(buffer.frameLength)
        var audioSamples = [Float32](repeating: 0, count: frameLength)
        for i in 0..<frameLength {
            audioSamples[i] = channelData[i]
        }

        // 모델이 요구하는 15600 길이에 맞게 패딩 또는 잘라내기
        let sampleCount = 15600
        if audioSamples.count < sampleCount {
            audioSamples.append(contentsOf: [Float32](repeating: 0, count: sampleCount - audioSamples.count))
        } else if audioSamples.count > sampleCount {
            audioSamples = Array(audioSamples[0..<sampleCount])
        }

        let mlArray = try? MLMultiArray(shape: [NSNumber(value: sampleCount)], dataType: .float32)
        for (index, sample) in audioSamples.enumerated() {
            mlArray?[index] = NSNumber(value: sample)
        }

        if let input = mlArray {
            do {
                let prediction = try model.prediction(audioSamples: input)
                
                // 예측 결과에서 확률 값 추출
                let probabilities = prediction.targetProbability
                DispatchQueue.main.async {
                    for (label, probability) in probabilities {
                        
                        if probability > 0.5{
                            print("Label: \(label), Probability: \(probability)")
                        }
                    }
                }
            } catch {
                print("Error in prediction: \(error.localizedDescription)")
            }
        }
    }
    
}
