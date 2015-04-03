//
//  DetailViewController.swift
//  Project7
//
//  Created by Hudzilla on 20/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
	var webView: WKWebView!
	var detailItem: [String : String]!

	override func loadView() {
		webView = WKWebView()
		view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		if let body = detailItem["body"] {
			var html = "<html>"
			html += "<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style> body { font-size: 150%; } </style> </head>"
			html += "<body>"
			html += body
			html += "</body>"
			html += "</html>"
			webView.loadHTMLString(html, baseURL: nil)
		}		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

