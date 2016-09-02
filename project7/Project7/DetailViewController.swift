//
//  DetailViewController.swift
//  Project7
//
//  Created by TwoStraws on 15/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
	var webView: WKWebView!
	var detailItem: [String: String]!

	override func loadView() {
		webView = WKWebView()
		view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard detailItem != nil else { return }

		if let body = detailItem["body"] {
			var html = "<html>"
			html += "<head>"
			html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
			html += "<style> body { font-size: 150%; } </style>"
			html += "</head>"
			html += "<body>"
			html += body
			html += "</body>"
			html += "</html>"
			webView.loadHTMLString(html, baseURL: nil)
		}
	}
}
