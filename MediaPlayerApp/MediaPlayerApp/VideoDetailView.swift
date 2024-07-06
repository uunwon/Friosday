//
//  VideoDetailView.swift
//  MediaPlayerApp
//
//  Created by uunwon on 7/6/24.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    @State var videoFileName: String
    @State private var player: AVPlayer?
    
    var body: some View {
//        let _ = print(videoFileName)
        
        VideoPlayer(player: player)
            .onAppear {
                loadVideo()
            }
            .onDisappear {
                player?.pause()
            }
            .ignoresSafeArea()
    }
    
    private func loadVideo() {
        let videoExtensions = ["mp4", "mov"]
        var url: URL?
        
        for ext in videoExtensions {
            if let fileURL = Bundle.main.url(forResource: videoFileName, withExtension: ext) {
                url = fileURL
                break
            }
        }
        
        guard let videoURL = url else {
            print("Video file not found")
            return
        }

        player = AVPlayer(url: videoURL)
        player?.play()
    }
}

//#Preview {
//    VideoDetailView()
//}
