//
//  NewsListView.swift
//  CombineProject
//
//  Created by uunwon on 6/21/24.
//

import SwiftUI

struct NewsListView: View {
    @StateObject var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.newsItems) { item in
                    NavigationLink(destination: NewsDetailView(item: item)) {
                        NewsRow(item: item)
                    }
                }
                if viewModel.hasMoreData, !viewModel.isLoading {
                    ProgressView()
                        .onAppear {
                            viewModel.loadMore()
                        }
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("뉴스 검색 (\(viewModel.newsItems.count) 건)")
        .searchable(text: $viewModel.searchQuery, prompt: "검색어를 입력하세요.")
        /*
            1. overlay: 뷰의 위에 다른 뷰를 겹쳐서 배치할 때 사용 (여기선 뷰 위에 오류 메시지를 겹쳐 표시)
            2. Group: 여러 개의 뷰를 그룹화해 하나의 뷰처럼 취급 (조건부 뷰 정의)
         */
        .overlay(
             Group {
                if let errorMessage = viewModel.errorMessage {
                   Text(errorMessage)
                       .foregroundColor(.red)
                       .padding()
                }
             }
        )
    }
    
}

#Preview {
    NewsListView()
}
