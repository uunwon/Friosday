//
//  NewsDetailView.swift
//  CombineProject
//
//  Created by uunwon on 6/22/24.
//

import SwiftUI
import WebKit

struct NewsDetailView: View {
    let item: NewsItem
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            WebView(url: URL(string: item.originallink)!, isLoading: $isLoading)
            if isLoading {
                ProgressView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(item.title)
    }
}

/*
    SwiftUI 에서 UIKit 뷰를 통합하여 사용할 때 'UIViewRepresentable' 프로토콜을 사용한다
    이때 UIKit 뷰의 동작을 제어하기 위해 Coordinator(SwiftUI 뷰와 UIKit 뷰 간 상호작용 관리) 를 사용 ✨
 */
struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    // WKWebView 인스턴스를 생성하고 초기화하는 메서드
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    // 뷰를 업데이트하는 메서드 (URL 요청을 로드)
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // Coordinator 인스턴스를 생성하는 메서드
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // WKNavigationDelegate 프로토콜을 구현해 웹 뷰의 탐색 이벤트를 처리하는 Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}
