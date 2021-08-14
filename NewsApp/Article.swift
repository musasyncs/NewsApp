//
//  Article.swift
//  NewsApp
//
//  Created by Ewen on 2021/8/10.
//

import Foundation

struct ArticleService: Decodable {
    var totalResults: Int?
    var articles: [Article]?
}

struct Article: Decodable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
}
