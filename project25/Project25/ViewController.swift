//
//  ViewController.swift
//  Project25
//
//  Created by Hudzilla on 17/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
	@IBOutlet weak var collectionView: UICollectionView!

	var images = [UIImage]()

	var peerID: MCPeerID!
	var mcSession: MCSession!
	var mcAdvertiserAssistant: MCAdvertiserAssistant!

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Selfie Share"
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(showConnectionPrompt))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(importPicture))

		peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
		mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .Required)
		mcSession.delegate = self
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageView", forIndexPath: indexPath)

		if let imageView = cell.viewWithTag(1000) as? UIImageView {
			imageView.image = images[indexPath.item]
		}

		return cell
	}

	func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		presentViewController(picker, animated: true, completion: nil)
	}

	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		var newImage: UIImage

		if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
			newImage = possibleImage
		} else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			newImage = possibleImage
		} else {
			return
		}

		dismissViewControllerAnimated(true, completion: nil)

		images.insert(newImage, atIndex: 0)
		collectionView.reloadData()

		// 1
		if mcSession.connectedPeers.count > 0 {
			// 2
			if let imageData = UIImagePNGRepresentation(newImage) {
				// 3
				do {
					try mcSession.sendData(imageData, toPeers: mcSession.connectedPeers, withMode: .Reliable)
				} catch let error as NSError {
					let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .Alert)
					ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
					presentViewController(ac, animated: true, completion: nil)
				}
			}
		}
	}

	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	func showConnectionPrompt() {
		let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .ActionSheet)
		ac.addAction(UIAlertAction(title: "Host a session", style: .Default, handler: startHosting))
		ac.addAction(UIAlertAction(title: "Join a session", style: .Default, handler: joinSession))
		ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		presentViewController(ac, animated: true, completion: nil)
	}

	func startHosting(action: UIAlertAction!) {
		mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
		mcAdvertiserAssistant.start()
	}

	func joinSession(action: UIAlertAction!) {
		let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
		mcBrowser.delegate = self
		presentViewController(mcBrowser, animated: true, completion: nil)
	}

	func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

	}

	func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {

	}

	func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
		
	}

	func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
		switch state {
		case MCSessionState.Connected:
			print("Connected: \(peerID.displayName)")

		case MCSessionState.Connecting:
			print("Connecting: \(peerID.displayName)")

		case MCSessionState.NotConnected:
			print("Not Connected: \(peerID.displayName)")
		}
	}

	func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
		if let image = UIImage(data: data) {
			dispatch_async(dispatch_get_main_queue()) { [unowned self] in
				self.images.insert(image, atIndex: 0)
				self.collectionView.reloadData()
			}
		}
	}
}

