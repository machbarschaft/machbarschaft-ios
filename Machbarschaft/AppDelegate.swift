//
//  AppDelegate.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
//import Passbase
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Passbase initilaization
        //Passbase.initialize(publishableApiKey: "3e27309be36f707c9fea64ef81f22d011ed52942952b9e96cb5e5eff7db2c13e")
        
        ConnectionHandler.shared.startMonitoring()

        //Firebase initialization
        FirebaseApp.configure()
        
        Firestore.firestore().collection("account").document("asdf").getDocument { (snapshot, error) in
            switch error {
            case is AuthenticationError:
                debugPrint(error?.localizedDescription)
            default:
                debugPrint(error?.localizedDescription)
            }
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            return
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
