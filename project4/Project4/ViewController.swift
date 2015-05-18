//
//  ViewController.swift
//  Project4
//
//  Created by Hudzilla on 19/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
	var webView: WKWebView!
	var progressView: UIProgressView!

	var websites = ["apple.com", "slashdot.org"]

	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let url = NSURL(string: "http://" + websites[0])!
		webView.loadRequest(NSURLRequest(URL: url))
		webView.allowsBackForwardNavigationGestures = true

		// add ourselves as observer. NB: if this were a more complicated app
		// we would need to remove ourselves as an observer as needed
		webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: "openTapped")

		progressView = UIProgressView(progressViewStyle: .Default)
		let progressButton = UIBarButtonItem(customView: progressView)

		let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: webView, action: "reload")

		toolbarItems = [progressButton, spacer, refresh]
		navigationController?.toolbarHidden = false
	}

	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}

	func openTapped() {
		let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .ActionSheet)

		for website in websites {
			ac.addAction(UIAlertAction(title: website, style: .Default, handler: openPage))
		}

		ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		presentViewController(ac, animated: true, completion: nil)
	}

	func openPage(action: UIAlertAction!) {
		let url = NSURL(string: "http://" + action.title)!
		webView.loadRequest(NSURLRequest(URL: url))
	}

	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		title = webView.title
	}

	func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
		if let url = navigationAction.request.URL {
			if let host = url.host {
				for website in websites {
					if host.rangeOfString(website) != nil {
						decisionHandler(.Allow)
						return
					}
				}
			}
		}

		decisionHandler(.Cancel)
	}
}

