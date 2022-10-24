//
//  AppDelegate.swift
//  CartActionButton
//
//  Created by Masher Shin on 2022/10/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if window == nil {
            window? = UIWindow(frame: UIScreen.main.bounds)
        }
        window?.makeKeyAndVisible()

        return true
    }

}

