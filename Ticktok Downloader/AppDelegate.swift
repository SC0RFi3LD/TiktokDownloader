//
//  AppDelegate.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var standard: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.standard.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNVC")
        AppDelegate.standard.window?.makeKeyAndVisible()
        return true
    }
}

