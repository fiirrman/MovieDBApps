//
//  AppDelegate.swift
//  MovieDBApps
//
//  Created by Firman Aminuddin on 7/16/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window{
            let nav = UINavigationController(rootViewController: GetSessionViewC())
            window.rootViewController = nav
            
            // CHECK IS LOGIN
            if let valueGuest = userDefaults.value(forKey: guestSessionKey) as? String{
                if valueGuest != ""{
                    let nav = UINavigationController(rootViewController: ListMovieViewC())
                    window.rootViewController = nav                }
            }
            
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

