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
        GIDSignIn.sharedInstance().clientID = Endpoints.Environment.googleClientId
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
      
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        self.callRootView()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        return handled
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if (url.scheme == "fb232113201864910")
//        {
//            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//        }
//        else
//        {
//            return (GIDSignIn.sharedInstance()?.handle(url))!
//        }
//    }

}


extension AppDelegate {
    
    func callRootView(){
        
        if let _ = userDef.value(forKey: "Auth_token") {

            let mainVC = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home")
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = mainVC
            appDel.window?.makeKeyAndVisible()
       
        }else{
            
            let mainVC = FlowController().instantiateViewController(identifier: "NavLaunch", storyBoard: "Main")
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = mainVC
            appDel.window?.makeKeyAndVisible()
        }
    }
}
