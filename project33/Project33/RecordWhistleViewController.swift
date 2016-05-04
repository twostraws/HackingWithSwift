//
//  RecordWhistleViewController.swift
//  Project33
//
//  Created by Hudzilla on 19/09/2015.
//  Copyright © 2015 Paul Hudson. All rights reserved.
//

import AVFoundation
import UIKit

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {
	var stackView: UIStackView!

	var recordButton: UIButton!
	var playButton: UIButton!

	var recordingSession: AVAudioSession!
	var whistleRecorder: AVAudioRecorder!
	var whistlePlayer: AVAudioPlayer!

	override func loadView() {
		super.loadView()

		view.backgroundColor = UIColor.grayColor()

		stackView = UIStackView()
		stackView.spacing = 30
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = UIStackViewDistribution.FillEqually
		stackView.alignment = UIStackViewAlignment.Center
		stackView.axis = .Vertical
		view.addSubview(stackView)

		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["stackView": stackView]))
		view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant:0))
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Record your whistle"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .Plain, target: nil, action: nil)

		recordingSession = AVAudioSession.sharedInstance()

		do {
			try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
			try recordingSession.setActive(true)
			recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
				dispatch_async(dispatch_get_main_queue()) {
					if allowed {
						self.loadRecordingUI()
					} else {
						self.loadFailUI()
					}
				}
			}
		} catch {
			self.loadFailUI()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func loadRecordingUI() {
		recordButton = UIButton()
		recordButton.translatesAutoresizingMaskIntoConstraints = false
		recordButton.setTitle("Tap to Record", forState: .Normal)
		recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
		recordButton.addTarget(self, action: #selector(recordTapped), forControlEvents: .TouchUpInside)
		stackView.addArrangedSubview(recordButton)

		playButton = UIButton()
		playButton.translatesAutoresizingMaskIntoConstraints = false
		playButton.setTitle("Tap to Play", forState: .Normal)
		playButton.hidden = true
		playButton.alpha = 0
		playButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
		playButton.addTarget(self, action: #selector(playTapped), forControlEvents: .TouchUpInside)
		stackView.addArrangedSubview(playButton)
	}

	func loadFailUI() {
		let failLabel = UILabel()
		failLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		failLabel.text = "Recording failed: please ensure the app has access to your microphone."
		failLabel.numberOfLines = 0

		stackView.addArrangedSubview(failLabel)
	}

	class func getDocumentsDirectory() -> NSString {
		let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
		let documentsDirectory = paths[0]
		return documentsDirectory
	}

	class func getWhistleURL() -> NSURL {
		let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("whistle.m4a")
		let audioURL = NSURL(fileURLWithPath: audioFilename)

		return audioURL
	}

	func startRecording() {
		// 1
		view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)

		// 2
		recordButton.setTitle("Tap to Stop", forState: .Normal)

		// 3
		let audioURL = RecordWhistleViewController.getWhistleURL()
		print(audioURL.absoluteString)

		// 4
		let settings = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000.0,
			AVNumberOfChannelsKey: 1 as NSNumber,
			AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
		]

		do {
			// 5
			whistleRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
			whistleRecorder.delegate = self
			whistleRecorder.record()
		} catch {
			finishRecording(success: false)
		}
	}

	func finishRecording(success success: Bool) {
		view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)

		whistleRecorder.stop()
		whistleRecorder = nil

		if success {
			recordButton.setTitle("Tap to Re-record", forState: .Normal)

			if playButton.hidden {
				UIView.animateWithDuration(0.35) { [unowned self] in
					self.playButton.hidden = false
					self.playButton.alpha = 1
				}
			}

			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(nextTapped))
		} else {
			recordButton.setTitle("Tap to Record", forState: .Normal)

			let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .Alert)
			ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(ac, animated: true, completion: nil)
		}
	}

	func recordTapped() {
		if whistleRecorder == nil {
			startRecording()

			if !playButton.hidden {
				UIView.animateWithDuration(0.35) { [unowned self] in
					self.playButton.hidden = true
					self.playButton.alpha = 0
				}
			}
		} else {
			finishRecording(success: true)
		}
	}

	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
		if !flag {
			finishRecording(success: false)
		}
	}

	func playTapped() {
		let audioURL = RecordWhistleViewController.getWhistleURL()

		do {
			whistlePlayer = try AVAudioPlayer(contentsOfURL: audioURL)
			whistlePlayer.play()
		} catch {
			let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .Alert)
			ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(ac, animated: true, completion: nil)
		}
	}

	func nextTapped() {
		let vc = SelectGenreViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
}
