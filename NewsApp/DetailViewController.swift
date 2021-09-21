//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Ewen on 2021/8/13.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var articleURL: String?

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        /// webView 的 navigationDelegate 設為 DetailViewController
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let articleURL = articleURL, let url = URL(string: articleURL) {
            let request = URLRequest(url: url)
            
            /// spinner 不再隱藏並開始轉
            spinner.alpha = 1
            spinner.startAnimating()
            
            webView.load(request)
        }
    }
}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// spinner 停住並隱藏
        spinner.stopAnimating()
        spinner.alpha = 0
    }
}
