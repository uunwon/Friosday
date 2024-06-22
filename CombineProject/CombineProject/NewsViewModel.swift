//
//  NewsViewModel.swift
//  CombineProject
//
//  Created by uunwon on 6/21/24.
//

import Foundation
import Combine

// 🍎 Combine 프레임워크를 사용해 뉴스 데이터를 관리하고, 뷰와 데이터를 연결하는 역할
// 뉴스 검색, 페이지네이션, 썸네일 가져오기 기능을 제공한다
class NewsViewModel: ObservableObject {
    //@Published 속성은 SwiftUI와 같은 프레임워크에서 변경사항을 감지하고 UI를 업데이트할 수 있도록 함
    @Published var newsItems: [NewsItem] = []
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var isLoading = false
    @Published var hasMoreData = false
    @Published private var currentPage = 1
    
    private let newsService = NewsService()
    private var cancellables = Set<AnyCancellable>() // Combine에서 구독을 저장하기 위한 Set
    
    private var totalPage = 0
    private let itemsPerPage = 20
    
    // 스트림은 lazy 로 만들어, 사용될 때 만들어지게끔
    // 🌊 searchNewsPublisher 은 사용자의 검색 쿼리를 처리하는 스트림
    private lazy var searchNewsPublisher: AnyPublisher<NewsResponse, Error> = {
        $searchQuery
            // 입력이 멈춘 후 지정된 시간 동안 대기하는 debounce
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            // 동일한 검색어가 연속으로 들어올 경우 중복 제거하는 removeDuplicates
            .removeDuplicates()
            // 빈 문자열 제외하는 filter
            .filter { !$0.isEmpty }
            // 검색 쿼리를 기반으로 뉴스 데이터를 가져오는 flatMap
            .flatMap { [weak self] query -> AnyPublisher<NewsResponse, Error> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                self.errorMessage = nil
                self.currentPage = 1
                self.hasMoreData = false
                return self.newsService.searchNews(query: query, page: self.currentPage, itemsPerPage: self.itemsPerPage)
            }
            // 여러 구독자가 동일한 스트림을 공유할 수 있도록 하는 share
            .share()
            // 타입을 AnyPublisher 로 변환하는 eraseToAnyPublisher
            .eraseToAnyPublisher()
    }()
    
    // 🌊 paginationPublisher 은 페이지네이션을 처리하는 스트림
    private lazy var paginationPublisher: AnyPublisher<[NewsItem], Error> = {
        $currentPage
            // 첫 페이지가 아닌 경우에만 처리하는 filter
            .filter { $0 > 1 }
            // 추가 데이터를 가져오는 flatMap
            .flatMap { [weak self] page -> AnyPublisher<[NewsItem], Error> in
                guard let self = self, !self.searchQuery.isEmpty else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.newsService.searchNews(query: self.searchQuery, page: page, itemsPerPage: self.itemsPerPage)
                    // 출력 이벤트를 처리해 총 페이지 수와 더 많은 데이터가 있는지 여부를 업데이트하는 handleEvents
                    .handleEvents(receiveOutput: { [weak self] response in
                        self?.totalPage = response.total
                        self?.hasMoreData = (self?.newsItems.count ?? 0) + response.items.count < response.total
                    })
                    // NewsResponse 에서 뉴스 항목 배열을 추출한 map
                    .map(\.items)
                    .eraseToAnyPublisher()
            }
            .share()
            .eraseToAnyPublisher()
    }()
    
    // 🌬️ 초기화 메서드에서 스트림 설정하기 💨
    init() {
        // 로딩 상태 추적 스트림
        searchNewsPublisher
            .map { _ in false }
            .catch { _ in Just(false) }
            .prepend(true)
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        /* 🐟
         paginationPublisher 구독을 설정해 페이지네이션 중 로딩 상태를 관리함
         (페이지네이션이 시작될 때와 완료될 때 isLoading 상태를 적절히 업데이트함)
         
         1. paginationPublisher: 페이지네이션 관련 이벤트를 방출하는 퍼블리셔, 페이지네이션 작업이 발생할 때마다 실행됨
         2. map {}: 페이지네이션 작업 완료시 isLoading을 false로 설정
                    - 실제 데이터가 아닌 불리언 값 방출하도록 변환함
                    - 모든 방출된 값은 false로 변환됨
         3. catch {}: 에러가 발생된 경우에도 isLoading 을 false로 설정
                    - 이는 에러 발생 시에도 로딩 상태를 적절히 업데이트하기 위함
                    - 에러 발생시 false 방출하는 퍼블리셔로 대체됨
         4. preprend(true): 페이지네이션 작업 시작시 isLoading 을 true 로 설정, 첫번째로 방출되는 값 🎬
         5. receive(on): 방출된 값을 메인 스레드에서 처리
         6. assign(to,on): 방출된 값을 self.isLoading에 할당
                    - 이는 뷰 모델의 isLoading 속성을 업데이트, 로딩 상태를 UI에 반영할 수 있도록 함
         7. store(in): 이 구독을 cancellables 컬렉션에 저장
                    - 이는 구독의 수명을 뷰 모델의 수명과 동일하게 유지하기 위함 (뷰모델 해제시 구독도 자동 취소)
         */
        paginationPublisher
            .map { _ in false }
            .catch { _ in Just(false) }
            .prepend(true)
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        // newsItems 데이터 바인딩 스트림
        searchNewsPublisher
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty() }
            .sink { [weak self] response in
                self?.newsItems = response.items
                self?.hasMoreData = response.items.count < response.total
                self?.totalPage = response.total
                self?.fetchThumnails(for: response.items)
            }
            .store(in: &cancellables)
        
        // 페이지네이션 데이터 바인딩 스트림
        paginationPublisher
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty() }
            .sink { [weak self] newsItems in
                self?.newsItems.append(contentsOf: newsItems)
                self?.fetchThumnails(for: newsItems)
            }
            .store(in: &cancellables)
        
        // 에러 메시지 출력 스트림
        searchNewsPublisher
            .receive(on: DispatchQueue.main)
            .map { _ in nil as String? }
            .catch { error -> AnyPublisher<String?, Never> in
                Just(error.localizedDescription).eraseToAnyPublisher()
            }
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    // 🦋 더 많은 데이터를 로드하기 위한 메서드
    func loadMore() {
        guard !isLoading, hasMoreData else { return }
        currentPage += 1
    }
    
    /* 🦋 뉴스 항목의 썸네일을 가져오는 메서드
     
     뉴스 항목의 URL 에서 HTML 을 가져오고, 이를 파싱해 썸네일 URL을 추출
     (네트워크 요청을 비동기적으로 수행, 결과를 메인스레드에서 처리해 UI 업데이트하는 일반적인 패턴 보여줌)
     
     1. dataTaskPublisher: URLSession 을 통해 네트워크 요청을 비동기적으로 수행하고, Publisher를 반환
     2. map(\.data) : Publisher에서 발행된 데이터에서 HTTP 응답의 본문만 추출
     3. map{} : HTTP 응답을 문자열로 변환, 실패시 빈 문자열 반환
     4. receive(on) : 이후의 모든 처리를 메인 스레드에서 수행하도록 지정
     5. sink : 퍼블리셔에서 발행된 값을 구독하고 처리. 두개의 클로저를 사용해 각 완료/성공 이벤트를 처리
            - 첫번째 클로저는 완료 이벤트(completion)를 처리, 실패시 에러 출력
            - 두번째 클로저는 성공 이벤트(receiveValue)를 처리, 썸네일 URL 업데이트하는 작업함
     6. store : 구독을 cancellables 라는 Set<AnyCancellabel> 에 저장해 메모리에서 해제되지 않도록 함
            - 이를 통해 필요 없을 때 구독을 취소할 수 있음
     */
    func fetchThumnails(for items: [NewsItem] = []) {
        for (index, item) in newsItems.enumerated() {
            guard var urlComponents = URLComponents(string: item.originallink) else { continue }
            
            // Force HTTPS
            urlComponents.scheme = "https"
            
            guard let url = urlComponents.url else { continue }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .map { String(data: $0, encoding: .utf8) ?? "" }
                .map { self.extractThumbnailURL(from: $0) }
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching thumbnail for \(item.title): \(error)")
                    }
                } receiveValue: { [weak self] thumbnailURL in
                    self?.updateThumbnail(for: item.id, with: thumbnailURL)
                }
                .store(in: &cancellables)
        }
    }
    
    // 🦋 뉴스 항목의 썸네일 URL을 업데이트하는 메서드
    // 주어진 뉴스 항목의 ID를 사용해 해당 항목을 찾아 썸네일 URL을 업데이트
    private func updateThumbnail(for itemId: UUID, with thumbnailURL: String?) {
        if let index = newsItems.firstIndex(where: { $0.id == itemId }) {
            newsItems[index].imageURL = thumbnailURL
        }
    }
    
    // 🦋 HTML 에서 썸네일 URL 을 추출하는 메서드
    func extractThumbnailURL(from html: String) -> String? {
        let patterns = [
            // Open Graph
            "<meta\\s+property=[\"']og:image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>",
            // Twitter Card
            "<meta\\s+name=[\"']twitter:image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>",
            // Standard meta image
            "<meta\\s+name=[\"']image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>",
            // Link tag with image
            "<link\\s+rel=[\"']image_src[\"']\\s+href=[\"'](.*?)[\"']\\s*/>",
            // First img tag src
            "<img\\s+[^>]*src=[\"'](.*?)[\"'][^>]*>",
            // Article:image (used by some sites)
            "<meta\\s+property=[\"']article:image[\"']\\s+content=[\"'](.*?)[\"']\\s*/>"
        ]
            
        for pattern in patterns {
            if let imageURL = html.range(of: pattern, options: .regularExpression)
                .flatMap({ result -> String? in
                    let fullMatch = html[result]
                    let quotationMarks = ["\"", "'"]
                    for mark in quotationMarks {
                        if let start = fullMatch.range(of: "\(mark)http")?.upperBound,
                            let end = fullMatch[start...].range(of: mark)?.lowerBound {
                            return String(fullMatch[start..<end])
                        }
                    }
                    return nil
                }) {
                return forceHTTPS(url: imageURL)
            }
        }
        return nil
    }
    
    // 🦋 URL의 스킴(http)을 HTTPS 로 강제하는 메서드 (데이터 전송 보안 강화를 위해)
    private func forceHTTPS(url: String) -> String {
        guard var urlComponents = URLComponents(string: url) else { return url }
        urlComponents.scheme = "https"
        return urlComponents.url?.absoluteString ?? url
    }
}
