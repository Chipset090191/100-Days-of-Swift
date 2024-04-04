//
//  WebView.swift
//  Project16
//
//  Created by Михаил Тихомиров on 12.01.2024.
//

import UIKit
import WebKit

// MARK: Challenge 3.2
class WebView: UIViewController {
    var webView:WKWebView!
    
    var site:String = ""

    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let url = URL(string: "https://en.wikipedia.org/wiki/\(site)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    
    



}
