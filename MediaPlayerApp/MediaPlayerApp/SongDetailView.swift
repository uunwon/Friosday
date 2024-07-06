//
//  SongDetailView.swift
//  MediaPlayerApp
//
//  Created by uunwon on 7/6/24.
//

import SwiftUI

struct SongDetailView: View {
    var audioPlayerManager = AudioPlayerManager()
    
    @State var audioFileName: String
    @State var playAudio = false
    
    var body: some View {
        VStack {
//            let _ = print("\($audioFileName)")
            
            Button(action: {
                if !playAudio {
                    audioPlayerManager.play()
                } else {
                    audioPlayerManager.pause()
                }
                playAudio.toggle()
            }, label: {
                Text(!playAudio ? "Play audio" : "Pause audio")
            })
        }
        .padding()
        .onAppear {
            audioPlayerManager.loadAudio(named: audioFileName, withExtension: "mp3")
        }
    }
}

//#Preview {
//    SongDetailView(audioFileName: $audioFileName)
//}
