//
//  AppDelegate.swift
//  DoubtNut
//
//  Created by Apple on 05/03/21.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleSignIn
import FBSDKCoreKit

var userDef = UserDefaults.standard


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        self.callRootView()
        return true
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    

//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//      // ...
//      if let error = error {
//        print(error)
//        // ...
//        return
//      }
//
//      guard let authentication = user.authentication else { return }
//      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                        accessToken: authentication.accessToken)
//        print(credential)
//      // ...
//    }

//    func sign(_ signIn: GIDSignIn!,didSignInFor user: GIDGoogleUser!,withError error: Error!) {
//
//        // Check for sign in error
//        if let error = error {
//            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                print("The user has not signed in before or they have since signed out.")
//            } else {
//                print("\(error.localizedDescription)")
//            }
//            return
//        }
//
//        // Get credential object using Google ID token and Google access token
//        guard let authentication = user.authentication else {
//            return
//        }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//
//        // Authenticate with Firebase using the credential object
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
//            }
//
//            // Post notification after user successfully sign in
//            print(authResult?.user.displayName)
//            print(authResult?.user.email)
//        }
//
//    }
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }

}


extension AppDelegate {
    
    func callRootView(){
        
        if let _ = userDef.value(forKey: "Auth_token") {
            if let count = userDef.value(forKey: "LoginCount") as? Int{
                if count > 5{
                    let mainVC = FlowController().instantiateViewController(identifier: "navDash", storyBoard: "Home")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.window?.rootViewController = mainVC
                    appDel.window?.makeKeyAndVisible()

                }else{
                    let mainVC = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.window?.rootViewController = mainVC
                    appDel.window?.makeKeyAndVisible()

                }
            }else{
                let mainVC = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home")
                let appDel = UIApplication.shared.delegate as! AppDelegate
                appDel.window?.rootViewController = mainVC
                appDel.window?.makeKeyAndVisible()

            }
            
       
        }else{
            
            let mainVC = FlowController().instantiateViewController(identifier: "NavLaunch", storyBoard: "Main")
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = mainVC
            appDel.window?.makeKeyAndVisible()
        }
    }
}
