//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Ewen on 2021/8/13.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
     
    var articleToDisplay: Article!  // !表示肯定會有文章傳入，之後就不用再unwrap articleToDisplay
    
    func displayArticle(_ article: Article) {
        // Reset cell 後才顯示下一篇文章
        headlineLabel.text = ""
        articleImageView.image = nil
        
        /// 淡入動畫初始值
        headlineLabel.alpha = 0
        articleImageView.alpha = 0
        

        // 文章 struct 傳給 property
        articleToDisplay = article
        
        // 標籤文字為 articleToDisplay 的 title
        headlineLabel.text = articleToDisplay.title
        
        /// Fade-in Animation
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.headlineLabel.alpha = 1
        }, completion: nil)
        
        //== 從網址下載圖片並顯示 ==//
        
        // 確保網址有圖片，否則直接return
        guard let urlString = articleToDisplay.urlToImage else {
            return
        }
        
        //=== 檢查 Cache manager，有圖片就用 cache 的顯示，沒圖片就繼續下載 ===//
        if let imageData = CacheManager.retrievedData(urlString) {
            articleImageView.image = UIImage(data: imageData)
            
            /// Fade-in Animation
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                self.articleImageView.alpha = 1
            }, completion: nil)
            
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("Can't create url object.")
            return
        }
        
        // 得到 URLSession 物件
        let session = URLSession.shared
        
        // 得到 dataTask 物件
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            // 檢查沒有 error 且有圖片資料
            if error == nil && data != nil {
                
                //=== 存圖片資料和 url string 進 Cache manager ===//
                CacheManager.saveData(urlString, data!)
                
                // 確認從 dataTask 回來的任務的 urlString，與目前的 articleToDisplay.urlToImage 仍然相同（可能因為 cell recycle 而不同）
                if self.articleToDisplay!.urlToImage == urlString {
                    
                    // 用 main thread 顯示圖片
                    DispatchQueue.main.async {
                         self.articleImageView.image = UIImage(data: data!)
                        
                        /// Fade-in Animation
                        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                            self.articleImageView.alpha = 1
                        }, completion: nil)
                    }
                }
            }
        }
        
        dataTask.resume()
     
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
