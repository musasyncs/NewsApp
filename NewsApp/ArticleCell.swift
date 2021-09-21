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
     
    var articleToDisplay: Article!  // Article!表示肯定會有文章傳入，之後就不用再unwrap
    
    func displayArticle(_ article: Article) {
        // Reset cell
        headlineLabel.text = ""
        articleImageView.image = nil
        
        /// 淡入動畫初始值
        headlineLabel.alpha = 0
        articleImageView.alpha = 0
        
        articleToDisplay = article //文章傳給屬性
        headlineLabel.text = articleToDisplay.title //顯示
        
        /// 淡入動畫
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.headlineLabel.alpha = 1
        })
        
        /* 從圖片網址下載圖片並顯示 */
        guard let urlString = articleToDisplay.urlToImage else { return }
        
        // 檢查 CacheManager，有圖片就用 cache 的顯示，沒圖片就繼續下載
        if let imageData = CacheManager.retrievedData(urlString) {
            articleImageView.image = UIImage(data: imageData) //顯示
            /// 淡入動畫
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                self.articleImageView.alpha = 1
            })
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if error == nil && data != nil {
                
                // 存圖片data和 urlString 進 CacheManager
                CacheManager.saveData(urlString, data!)
                
                //重要：確認從 dataTask 回來的任務的 urlString，與目前的 articleToDisplay.urlToImage 仍然相同（可能因 cell recycle 而不同）
                if self.articleToDisplay!.urlToImage == urlString {
                    
                    DispatchQueue.main.async {
                         self.articleImageView.image = UIImage(data: data!)
                        /// 淡入動畫
                        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                            self.articleImageView.alpha = 1
                        })
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
