//
//  ArticleModel.swift
//  NewsApp
//
//  Created by Ewen on 2021/8/10.
//

import Foundation

protocol ArticleModelProtocol {
    func articlesRetrieved(_ articles:[Article])
}

class ArticleModel {
    var delegate: ArticleModelProtocol?
    
    func getArticles() {        
        let urlString = "https://newsapi.org/v2/top-headlines?country=tw&apiKey=bc8673d62d5e4a989020a3884354186f"
        guard let url = URL(string: urlString) else {
            print("Can't find json data.")
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if error == nil && data != nil {
                do {
                    let articleService = try JSONDecoder().decode(ArticleService.self, from: data!)
                    let articles = articleService.articles!
                    DispatchQueue.main.async {
                        self.delegate?.articlesRetrieved(articles)
                    }
                }
                catch {
                    print("Can't parse JSON.")
                }
            }
        }        
        dataTask.resume()
    }
}
