//
//  DetailViewController.swift
//  Project7
//
//  Created by Михаил Тихомиров on 20.11.2023.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
                <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1">
                        <style>
                            body {
                                padding: 0 10px;
                            }
                            h2 {
                                text-align: center;
                            }
                            p {
                                font-size: 115%;
                            }
                        </style>
                    </head>
                    <body>
                        <h2>\(detailItem.title)</h2>
                        <p>\(detailItem.body)</p>
                        <i>Signature Count: \(detailItem.signatureCount)</i>
                    </body>
                </html>
        """
        
        
   // old one
//        let html2 = """
//        <html>
//        <head>
//        <meta name="viewport" content="width=device-width, initial-scale=1">
//        <style> body { font-size: 150%; } </style>
//        </head>
//        <body>
//        \(detailItem.body)
//        </body>
//        </html>
//        """
        
        
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
