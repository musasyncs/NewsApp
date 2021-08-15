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
        
        // 發 request 到 API
        
        // 得到 URL 物件 url
        let urlString = "https://newsapi.org/v2/top-headlines?country=tw&apiKey=bc8673d62d5e4a989020a3884354186f"
        guard let url = URL(string: urlString) else {
            print("Can't find json data.")
            return
        }
        
        // 得到 URLSession 物件
        let session = URLSession.shared
        
        // 得到 dataTask 物件
        let dataTask = session.dataTask(with: url) { data, response, error in
            // 檢查沒有 error 且有資料
            if error == nil && data != nil {
                do {
                    // 用 JSON Decoder物件 JSONDecoder()，把資料 decode 成 ArticleService物件：articleService
                    let articleService = try JSONDecoder().decode(ArticleService.self, from: data!)
                    // 取得 articleService 的 articles陣列：articles
                    let articles = articleService.articles!
                    
                    // 通知在 main thread 的 view controller
                    DispatchQueue.main.async {
                        // delegate 使用 questionRetrieved方法傳進 articles
                        self.delegate?.articlesRetrieved(articles)
                    }
                }
                catch {
                    print("Can't parse JSON.")
                }
            }
        }
        
        // Call resume on the data task
        dataTask.resume()
    }
}
