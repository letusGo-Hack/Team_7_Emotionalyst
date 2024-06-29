//
//  CoreEngine.swift
//  Emotionalyst
//
//  Created by lukaOS on 6/29/24.
//


import AVFoundation
import Accelerate
import AVFAudio
import CoreML

class CoreEngine: ObservableObject {
    
    private let eqNode = AVAudioUnitEQ(numberOfBands: 1)
    private lazy var eqFilterParameters: AVAudioUnitEQFilterParameters = eqNode.bands[0] as AVAudioUnitEQFilterParameters
    var audioEngine: AVAudioEngine!
    var inputNode: AVAudioInputNode!
    var model: Emotion_Analstics_Gish?
    
    @Published var rmsData: Float = 0.0
    
    init() {
        self.audioEngine = AVAudioEngine()
        self.inputNode = audioEngine.inputNode
        self.eqFilterParameters.filterType = .bandPass
        self.eqFilterParameters.bypass = false
        self.eqFilterParameters.frequency = 40000
        let format = inputNode.outputFormat(forBus: 0)
        audioEngine.attach(eqNode)
        audioEngine.connect(inputNode, to: eqNode, format: format)
        
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
            guard let channelData = buffer.floatChannelData else { return }
            let channelDataValue = channelData.pointee
            let frames = buffer.frameLength
            let rmsValue = self.rms(data: channelDataValue, frameLength: UInt(frames))
            self.rmsData = rmsValue
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
            print(eqNode.bands[0].frequency)
        }catch{
            print("AudioEngine start error: \(error.localizedDescription)")
        }
    }
    
    static func readBuffer(_ audioFile: AVAudioFile) -> [Float] {
        let audioFormat = audioFile.processingFormat
        let audioFrameCount = UInt32(audioFile.length)
        guard
          let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
        else {
          return []
        }
        do {
          try audioFile.read(into: buffer)
        } catch {
          print("Read Buffer Error")
        }

        let floatArray = Array(UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength)))

        return floatArray
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
    
    private func rms(data: UnsafeMutablePointer<Float>, frameLength: UInt) -> Float {
        var val : Float = 0
        vDSP_measqv(data, 1, &val, frameLength)
        val *= 1000
        return val
    }
    
    /*
    var audioEngine: AVAudioEngine!
    var inputNode: AVAudioInputNode!
    var model: Emotion_Analstics_Gish?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        
        // CoreML 모델 초기화
        do {
            model = try Emotion_Analstics_Gish(configuration: MLModelConfiguration())
        } catch {
            print("Error initializing model: \(error.localizedDescription)")
        }
        
        let button = UIButton(type: .system)
        button.setTitle("Start Analysis", for: .normal)
        button.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        self.view.addSubview(button)
    }

    @objc func startRecording() {
        startAudioEngine()
    }
    
    func startAudioEngine() {
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.analyzeAudio(buffer: buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine start error: \(error.localizedDescription)")
        }
    }

    func analyzeAudio(buffer: AVAudioPCMBuffer) {
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
    */
    
}
