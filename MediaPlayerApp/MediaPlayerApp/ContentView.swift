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
        FileItem(name: "song", children: [
            FileItem(name: "song"), FileItem(name: "song2")]),
        FileItem(name: "video", children: [
            FileItem(name: "video"), FileItem(name: "video2"), FileItem(name: "video3")])
    ]
    
    var body: some View {
        NavigationStack {
            List(mediaFiles, children: \.children) { item in
                Text(item.description)
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
