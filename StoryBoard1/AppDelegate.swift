//
//  AppDelegate.swift
//  StoryBoard1
//
//  Created by Jenna Smith on 6/26/20.
//  Copyright © 2020 Unmasked Solutions. All rights reserved.
//

// TODO: handle attributes for images and information

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GoogleSignIn
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyAZp0ioBR22zyq_K-V1nkNPBQzOGQio6zU")
        GMSPlacesClient.provideAPIKey("AIzaSyAZp0ioBR22zyq_K-V1nkNPBQzOGQio6zU")
        
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        
        // get view controlelr
//        let authViewController = authUI?.authViewController()
        
        
        
        // Firebase User Auth
//        var actionCodeSettings = ActionCodeSettings()
//        actionCodeSettings.url = URL(string: "https://example.appspot.com")
//        actionCodeSettings.handleCodeInApp = true
//        actionCodeSettings.setAndroidPackageName("com.firebase.example", installIfNotAvailable: false, minimumVersion: "12")
//
//        let provider = FUIEmailAuth(authUI: FUIAuth.defaultAuthUI()!,
//                                    signInMethod: FIREmailLinkAuthSignInMethod,
//                                    forceSameDevice: false,
//                                    allowNewEmailAccounts: true,
//                                    actionCodeSetting: actionCodeSettings)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }



    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
      
        Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
//          let authError = error as NSError
            // ...
            return
        }
        // User is signed in
        
        print("user is signed in")
        }
        
    }

}

