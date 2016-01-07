//
//  InterfaceController.swift
//  Project37 WatchKit Extension
//
//  Created by Hudzilla on 06/01/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import WatchConnectivity
import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WCSessionDelegate {
	@IBOutlet var welcomeText: WKInterfaceLabel!
	@IBOutlet var hideButton: WKInterfaceButton!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

		if (WCSession.isSupported()) {
			let session = WCSession.defaultSession()
			session.delegate = self
			session.activateSession()
		}
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

	@IBAction func hideWelcomeText() {
		welcomeText.setHidden(true)
		hideButton.setHidden(true)
	}

	func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
		WKInterfaceDevice().playHaptic(.Click)
	}
}
