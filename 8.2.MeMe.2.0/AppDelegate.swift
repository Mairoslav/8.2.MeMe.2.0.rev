//
//  AppDelegate.swift
//  4.1imagePicker
//
//  Created by mairo on 19/03/2022.
//

import UIKit

// MARK: - AppDelegate: UIResponder, UIApplicationDelegate

@main class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    
    var memes = [Meme]() // new 2.0, shared model
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // remove border of the navigationBar -> no thin line on screen
        UINavigationBar.appearance().shadowImage = UIImage()
        
        // remove border of the Toolbar -> no thin line on screen
        UIToolbar.appearance().setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        
        return true
    }
    
}

