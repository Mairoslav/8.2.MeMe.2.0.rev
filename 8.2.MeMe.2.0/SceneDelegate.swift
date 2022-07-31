//
//  SceneDelegate.swift
//  4.1imagePicker
//
//  Created by mairo on 19/03/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // since using a storyboard, the `window` property is automatically initialized and attached to the scene. Therefore from AppDelegated deleted var window: UIWindow?
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }
}

