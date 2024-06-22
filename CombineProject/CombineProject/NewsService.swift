//
//  NewsService.swift
//  CombineProject
//
//  Created by uunwon on 6/21/24.
//

import Foundation
import Combine

// Combine 을 사용해 네이버 검색 API 에서 뉴스를 검색하는 클래스
struct NewsService {
    private let baseURL = "https://openapi.naver.com/v1/search/news.json"
    
    func searchNews(query: String, page: Int, itemsPerPage: Int) -> AnyPublisher<NewsResponse, Error> {
        // URLComponents 는 URL 개발 구성 요소(스킴, 호스트, 경로, 쿼리 등) 관리하는 클래스
        // 1️⃣ URLComponents 을 사용해 URL 을 동적으로 생성하고,
        guard var components = URLComponents(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        // 2️⃣ URL 의 쿼리 파라미터를 설정한 다음,
        // 검색어(query), 페이지네이션을 위한 시작 인덱스(start), 페이지당 항목 수(display)
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            // (몰?루) 현재 페이지와 페이지당 항목 수를 기반으로 시작 인덱스를 계산한다
            URLQueryItem(name: "start", value: String((page - 1) * itemsPerPage + 1)),
            URLQueryItem(name: "display", value: String(itemsPerPage))
        ]
        
        // 3️⃣ URL 을 검증하는 과정을 수행한다.
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue(Storage().naverClientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(Storage().naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        // dataTaskPublisher는 지정된 URL 요청('request')에 대해 데이터 가져오는 Publisher를 반환함
        // 이 Publisher는 네트워크 요청 시작하고, 요청 완료하면 Data와 URLResponse 전달함
        return URLSession.shared.dataTaskPublisher(for: request)
            // Publisher 의 출력 값을 반환, 키 경로를 통해 응답에서 data 만 추출
            .map(\.data)
            // Data 를 지정된 타입(NewsResponse)🔥으로 디코딩
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            // Publiser의 이벤트가 지정된 스케줄러(메인 스레드)에서 처리되도록 함
            // UI 업데이트는 메인 스레드에서 수행되어야 하므로, 필수 단계 ✨
            .receive(on: DispatchQueue.main)
            // 🌟 Publisher 를 AnyPublisher 타입으로 변환
            // 이 연산자는 내부의 구체적인 Publisher 타입 숨기고, 외부에 표준 인터페이스만 제공하는데 사용됨
            // 반환 타입을 AnyPublisher<NewsResponse, Error> 로 통일함
            .eraseToAnyPublisher()
    }
}
