//
//  RecordAnalyst.swift
//  Emotionalyst
//
//  Created by Hosung Lim on 6/29/24.
//

import Foundation
import AVFoundation
import SoundAnalysis
import UIKit
import CoreML

class ViewController: UIViewController {
    
    var audioFileAnalyzer: SNAudioFileAnalyzer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let audioURL = Bundle.main.url(forResource: "fileName", withExtension: "m4a") else {
            fatalError("Audio file not found.")
        }
        
        do {
            audioFileAnalyzer = try SNAudioFileAnalyzer(url: audioURL)
        } catch {
            fatalError("Unable to initialize SNAudioFileAnalyzer: \(error.localizedDescription)")
        }
        
        analyzeAudio()
    }
    
    func analyzeAudio() {
        guard let model = try? SNClassifySoundRequest(mlModel: Emotion_Analstics_Gish().model) else {
            fatalError("Unable to create SNClassifySoundRequest")
        }
        
        do {
            try audioFileAnalyzer.add(model, withObserver: self)
            audioFileAnalyzer.analyze()
        } catch {
            fatalError("Unable to add request to analyzer: \(error.localizedDescription)")
        }
    }
}

extension ViewController: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        
        let classifications = result.classifications
        let topClassification = classifications.first
        
        print("Classification: \(topClassification?.identifier ?? "N/A") Confidence: \(topClassification?.confidence ?? 0)")
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Failed with error: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("Request completed successfully!")
    }
}

