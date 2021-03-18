//
//  NewsFeed.swift
//  jsonparser
//
//  Created by Oğuzhan Varsak on 19.03.2021.
//

import Foundation

struct NewsFeed: Codable {
    var status: String?
    var totalResults: Int?
    struct Article: Codable {
        var source: Source
        var author: String?
        var title: String?
        var description: String?
        var url: String?
        var urlToImage: String?
        var publishedAt: String?
        var content: String?
        
        struct Source: Codable {
            var id: String?
            var name: String?
        }
    }
    
    var articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}
