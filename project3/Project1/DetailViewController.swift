//
//  DetailViewController.swift
//  Project1
//
//  Created by TwoStraws on 12/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Social
import UIKit

class DetailViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()

		title = selectedImage
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

		if let imageToLoad = selectedImage {
			imageView.image  = UIImage(named: imageToLoad)
		}
    }

	func shareTapped() {
		let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)

		//if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
		//	vc.setInitialText("Look at this great picture!")
		//	vc.add(imageView.image!)
		//	vc.add(URL(string: "http://www.photolib.noaa.gov/nssl"))
		//	present(vc, animated: true)
		//}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
