//
//  AudioPlayerManager.swift
//  MediaPlayerApp
//
//  Created by uunwon on 7/6/24.
//

import Foundation
import AVFoundation

class AudioPlayerManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    
    @Published var progress: CGFloat = 0.4
    @Published var isPlay: Bool = false // 예제에는 playing 변수로 !
    @Published var duration: Double = 0.0
    @Published var formattedDuration: String = "05:00"
    @Published var formattedProgress: String = "00:00"
    
    func loadAudio(named fileName: String, withExtension ext: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
            print("Audio file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            setTimer()
        } catch {
            print("Error loading audio: \(error.localizedDescription)")
        }
    }
    
    func setTimer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
         
        // 42번째줄 다 느낌표로 바꾸는게 불안하지만 다음 기회에 . .
        formattedDuration = formatter.string(from: TimeInterval(audioPlayer!.duration))!
        duration = audioPlayer!.duration
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !self.audioPlayer!.isPlaying {
                self.isPlay = false
            }
            
            self.progress = CGFloat(self.audioPlayer!.currentTime / self.audioPlayer!.duration)
            self.formattedProgress = formatter.string(from: TimeInterval(self.audioPlayer!.currentTime))!
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlay.toggle()
    }
    
    func backPlay() {
        let decrease = self.audioPlayer!.currentTime - 5.0
        if decrease < 0.0 {
            audioPlayer!.currentTime = 0.0
        } else {
            audioPlayer!.currentTime -= 5.0
        }
    }
    
    func nextPlay() {
        let increase = audioPlayer!.currentTime + 5.0
        if increase < audioPlayer!.duration {
            audioPlayer!.currentTime = increase
        } else {
            audioPlayer!.currentTime = duration
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlay.toggle()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
}
