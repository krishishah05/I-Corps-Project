//
//  AudioRecorder.swift
//  Broker
//
//  Created by 何偉銘 on 3/24/24.
//

import Foundation
import AVFoundation
import SwiftUI

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    override init(){
            super.init()
        }
    
    func startRecording(filePath: URL) {
        print("Record to file")
        print(filePath)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleIMA4),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
        ]
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up the audio session: \(error.localizedDescription)")
        }
        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print("Could not start recording: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        //audioRecorder = nil
        print("stoped")
    }
    
    //@State private var audioPlayer: AVAudioPlayer?
    func playSound() {
        print("Play sound file")
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed: \(error)")
        }
        do {
            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("recording.aif")
            print(filePath)
            audioPlayer = try AVAudioPlayer(contentsOf: filePath)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Couldn't play sound file")
        }
    }
}
