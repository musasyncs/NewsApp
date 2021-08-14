//
//  ViewController.swift
//  NewsApp
//
//  Created by Ewen on 2021/8/10.
//

import UIKit

class ViewController: UIViewController {

    var model = ArticleModel()
    var articles = [Article]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // model 的 delegate 設為 ViewController
        model.delegate = self
        // 從 article model 獲取 articles
        model.getArticles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        guard indexPath != nil else {
            return
        }
        // 點選到的 article
        let article = articles[indexPath!.row]
        
        // Get a reference to DetailViewController
        let detailVC = segue.destination as! DetailViewController
        
        // 傳 url string 給 DetailViewController
        detailVC.articleURL = article.url!
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 讓 tableView 知道文章總數
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ArticleCell.self)", for: indexPath) as! ArticleCell
        
        // 第 indexPath.row 位置的文章，傳入 cell 的 displayArticle 方法
        let article = articles[indexPath.row]
        cell.displayArticle(article)
        
        // return the cell
        return cell
    }
    
    // MARK: - UITableViewDelegate Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
}

extension ViewController: ArticleModelProtocol {
    // MARK: - ArticleModelProtocol Method
    func articlesRetrieved(_ articles: [Article]) {
        print("Articles returned from model!")
        
        // 設定 articles property 為從 model 傳來的 articles
        self.articles = articles
        
        // Refresh table view
        tableView.reloadData()
    }
}
