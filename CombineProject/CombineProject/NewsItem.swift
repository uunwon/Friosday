//
//  NewsItem.swift
//  CombineProject
//
//  Created by uunwon on 6/22/24.
//

import Foundation

// 뉴스 기사를 표현할 모델, Codable 프로토콜을 준수함 -- Data Model
// 뉴스 API로부터 데이터를 받아와 디코딩하고, 필요한 경우 HTML 문자열을 처리해 사용자에게 보여줌
struct NewsItem: Codable, Identifiable {
    let id = UUID()
    let title: String
    let originallink: String
    let link: String
    let description: String
    let pubDate: String
    var imageURL: String?
    
    // JSON 키와 구조체 속성 같의 매핑을 정의하는 CodingKeys
    enum CodingKeys: String, CodingKey {
        case title, link, originallink, description, pubDate
    }
    
    // 커스텀 초기화 메서드를 통해 JSON 디코딩 시 HTML 문자열을 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = NewsItem.decodeHTMLString(try container.decode(String.self, forKey: .title))
        link = try container.decode(String.self, forKey: .link)
        originallink = try container.decode(String.self, forKey: .originallink)
        description = NewsItem.decodeHTMLString(try container.decode(String.self, forKey: .description))
        pubDate = try container.decode(String.self, forKey: .pubDate)
    }
    
    // decodeURLEncodedString(_:) URL 인코딩된 문자열을 디코딩함
    static func decodeURLEncodedString(_ string: String) -> String {
        return string.removingPercentEncoding ?? string
    }
    
    // decodeHTMLString(_:) HTML 문자열을 디코딩하여 텍스트로 변환함
    static func decodeHTMLString(_ htmlString: String) -> String {
        
        // 입력된 HTML 문자열을 utf-8 인코딩을 사용해 Data 타입으로 변환, 실패시 원래 문자열 반환
        guard let data = htmlString.data(using: .utf8) else {
            return htmlString
        }
        
        // HTML 문자열을 디코딩하기 위한 옵션 설정
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        // NSAttributedString 이용해 HTML 데이터를 디코딩함
        // NSAttributedString 은 서식 있는 텍스트를 표현할 수 있는 클래스
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return htmlString
        }
        
        return attributedString.string
    }
}

// 뉴스 응답을 표현하는 모델 NewsResponse
struct NewsResponse: Codable {
    let total: Int
    let items: [NewsItem]
}

// API 에러 발생했을 때 에러 메시지 출력하기 위한 APIErrorMessage
struct APIErrorMessage: Decodable {
    var errorMessage: Bool
    var errorCode: String
}
