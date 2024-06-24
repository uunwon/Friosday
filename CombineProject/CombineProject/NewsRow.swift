//
//  NewsRow.swift
//  CombineProject
//
//  Created by uunwon on 6/22/24.
//

import SwiftUI

struct NewsRow: View {
    let item: NewsItem
    
    var body: some View {
        HStack {
            if let imageURL = item.imageURL {
                // 비동기적으로 이미지를 로드하는 AsyncImage 뷰
                AsyncImage(url: URL(string: imageURL)) { image in
                    image.resizable()
                        .frame(width: 90, height: 60)
                        .aspectRatio(contentMode: .fit)
                } placeholder: { // 이미지 로드하는 동안 표시할 placeholder 로
                    ProgressView() // 얘를 사용함 🫥
                        .frame(width: 90, height: 60, alignment: .center)
                }
            }
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.pubDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
