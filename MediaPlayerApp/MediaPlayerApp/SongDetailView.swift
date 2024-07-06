//
//  SongDetailView.swift
//  MediaPlayerApp
//
//  Created by uunwon on 7/6/24.
//

import SwiftUI
import AVFoundation

struct SongDetailView: View {
    var audioPlayerManager = AudioPlayerManager()
    
    @State var audioFileName: String
    @State var playAudio = false
    
    @State var progress: CGFloat = 0.4
    @State private var playing: Bool = false
    @State var duration: Double = 0.0
    @State var formattedDuration: String = "05:00"
    @State var formattedProgress: String = "00:00"
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.down")
                    .font(.system(size: 19, weight: .light))
                    .tint(Color.white)
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            Image("album")
                .resizable()
                .frame(height: 400)
            
            GeometryReader { geo in
                Capsule()
                    .stroke(Color.gray, lineWidth: 1)
                    .background(
                        Capsule()
                            .foregroundStyle(Color.white)
                            .frame(width: geo.size.width * progress, height: 3), alignment: .leading)
            }.frame(height: 3)
            
            HStack {
                Text(formattedProgress)
                    .font(.system(size: 14))
                    .padding(.leading)
                    
                Spacer()
                
                Text(formattedDuration)
                    .font(.system(size: 14))
                    .padding(.trailing)
            }
            .padding(.top, 5.0)
            
            HStack {
                Image(systemName: "apple.terminal")
                    .font(.system(size: 19, weight: .light))
                    .padding()
                Spacer()
                
                Image(systemName: "heart")
                    .font(.system(size: 19, weight: .light))
                
                Spacer()
                Image(systemName: "rays")
                    .font(.system(size: 19, weight: .light))
                    .padding()
            }
            .padding(.bottom, 20.0)
            
            Text("Right Now")
                .font(.system(size: 20))
                .padding(.bottom, 3.0)
            
            Text("NewJeans")
                .font(.system(size: 13))
            
            Spacer()
            
            HStack {
                Image(systemName: "arrow.rectanglepath")
                    .font(.system(size: 17, weight: .light))
                    .padding(.leading)
                
                Spacer()
                
                Image(systemName: "backward.end")
                    .font(.system(size: 30, weight: .thin))
                
                Spacer()
                
                Button(action: {
                    if !playAudio {
                        audioPlayerManager.play()
                    } else {
                        audioPlayerManager.pause()
                    }
                    playAudio.toggle()
                }, label: {
                    Image(systemName: !playAudio ? "play" : "pause")
                        .tint(colorScheme == .dark ? Color.white : Color.black)
                        .font(.system(size: 45, weight: .thin))
                })
                
                Spacer()
                
                Image(systemName: "forward.end")
                    .font(.system(size: 30, weight: .thin))
                
                Spacer()
                
                Image(systemName: "shuffle")
                    .font(.system(size: 17, weight: .light))
                    .padding(.trailing)
            }
            .padding(.top, 20.0)
            
            Spacer()
            
            HStack {
                Text("EQ AAC 128k")
                    .font(.system(size: 10))
                    .padding()
                
                Spacer()
                
                Text("연관 곡")
                    .font(.system(size: 12))
                
                Image(systemName: "control")
                    .font(.system(size: 13))
                    .padding(.trailing, 35.0)
                
                Spacer()
                
                Image(systemName: "text.append")
                    .font(.system(size: 17, weight: .light))
                    .padding()
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true) // to custom back button
        .navigationBarItems(trailing: backButton)
        .onAppear {
            audioPlayerManager.loadAudio(named: audioFileName, withExtension: "mp3")
        }
    }
}

#Preview {
    SongDetailView(audioFileName: "song")
        .preferredColorScheme(.dark)
}
