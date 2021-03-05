//
//  AppDelegate.swift
//  DoubtNut
//
//  Created by Apple on 05/03/21.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

var userDef = UserDefaults.standard


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance().clientID = Endpoints.Environment.googleClientId
        
        self.callRootView()
        return true
    }

   

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (url.scheme == "fb232113201864910")
        {
            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else
        {
            return (GIDSignIn.sharedInstance()?.handle(url))!
        }
    }

}


extension AppDelegate {
    
    func callRootView(){
        
        if let _ = userDef.object(forKey: "userInfo") as? Data {
            let _ = JSONDecoder()
//            if let userM = try? decoder.decode(User_info.self, from: userInfo) {
//                userGlobal = userM
//                let _window = UIWindow(frame: UIScreen.main.bounds)
//                window = _window
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
//                let rootViewController = initialViewController
//                let navigationController = UINavigationController()
//                navigationController.navigationBar.isHidden = true
//                navigationController.viewControllers = [rootViewController]
//                window?.rootViewController = navigationController
//                window?.makeKeyAndVisible()
//            }
        }
        else{
            let _window = UIWindow(frame: UIScreen.main.bounds)
            window = _window
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            let rootViewController = initialViewController
            let navigationController = UINavigationController()
            navigationController.navigationBar.isHidden = true
            navigationController.viewControllers = [rootViewController]
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
}
