//
//  SceneDelegate.swift
//  Project32
//
//  Created by Carrione on 17/12/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit
import CoreSpotlight

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                if let navigationController = window?.rootViewController as? UINavigationController {
                    if let viewController = navigationController.topViewController as? ViewController {
                        viewController.showTutorial(Int(uniqueIdentifier)!)
                    }
                }
            }
        }
    }
}
