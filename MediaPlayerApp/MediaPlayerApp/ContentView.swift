//
//  ContentView.swift
//  MediaPlayerApp
//
//  Created by uunwon on 7/5/24.
//

import SwiftUI

struct ContentView: View {
    @State var searchText = ""
    
    let mediaFiles: [FileItem] = [
        FileItem(name: "audio", children: [
            FileItem(name: "Right Now"), FileItem(name: "Supernatural")]),
        FileItem(name: "video", children: [
            FileItem(name: "video"), FileItem(name: "video2"), FileItem(name: "video3")])
    ]
    
    var body: some View {
        NavigationStack {
            List(mediaFiles, children: \.children) { item in
                if let children = item.children {
                    Text(item.description)
                } else {
                    let textIndex = item.description.index(item.description.startIndex, offsetBy: 2)
                    
                    let parentName = mediaFiles.first { $0.children?.contains(item) ?? false }?.name
                    
                    NavigationLink {
                        if parentName == "audio" {
                            SongDetailView(audioFileName: String(item.description[textIndex...]))
                        } else {
                            VideoDetailView(videoFileName: String(item.description[textIndex...]))
                        }
                    } label: {
                        Text(item.description)
                    }
                }
            }
            .navigationTitle("File")
            .toolbar {
                Button {
                    // MARK: - 파일 추가 같은 작업 ..
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always))
    }
}

#Preview {
    ContentView()
         .preferredColorScheme(.dark)
}
