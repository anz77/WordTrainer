//
//  SpeechSyntesizerService.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 20.12.2020.
//

//import Foundation
import AVFoundation

// Create an utterance.

class SpeechSyntesizerService {
    
    func speechUttreance(string: String) {
        
        do {
            let _ = try AVAudioSession.sharedInstance().setCategory(.soloAmbient, options: .duckOthers)
        } catch {
            print(error)
        }
        
        let utterance = AVSpeechUtterance(string: string)

        // Configure the utterance.
        utterance.rate = 0.30
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8

        // Retrieve the British English voice.
        let voice = AVSpeechSynthesisVoice(language: "en-US")

        // Assign the voice to the utterance.
        utterance.voice = voice

        // Create a speech synthesizer.
        let synthesizer = AVSpeechSynthesizer()
    
        synthesizer.usesApplicationAudioSession = true

        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)
    }
}
