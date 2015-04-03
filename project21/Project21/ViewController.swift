//
//  ViewController.swift
//  Project21
//
//  Created by Hudzilla on 24/11/2014.
//  Copyright (c) 2014 Hudzilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func registerLocal(sender: AnyObject) {
		let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil)
		UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
	}

	@IBAction func scheduleLocal(sender: AnyObject) {
		let settings = UIApplication.sharedApplication().currentUserNotificationSettings()

		if settings.types == .None {
			// user has refused us access to this, or we haven't asked yet
			let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
			ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(ac, animated: true, completion: nil)
			return
		}

		let notification = UILocalNotification()
		notification.fireDate = NSDate(timeIntervalSinceNow: 5)
		notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
		notification.alertAction = "be awesome!"
		notification.soundName = UILocalNotificationDefaultSoundName
		notification.userInfo = ["CustomField1": "w00t"]
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}
}

