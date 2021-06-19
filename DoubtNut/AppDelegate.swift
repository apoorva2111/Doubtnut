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
import UXCam
var userDef = UserDefaults.standard


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window:UIWindow?

    private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let lockState = cfName?.rawValue as String? else {return}
print(lockState)
        if (lockState == "com.apple.springboard.lockcomplete") {
               print("DEVICE LOCKED")
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)

           } else {
               print("LOCK STATUS CHANGED")
           }

       
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        registerforDeviceLockNotification()
        self.callRootView()
        UXCam.optIntoSchematicRecordings()
        UXCam.start(withKey:"App-key from UXCam")

        return true
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    func registerforDeviceLockNotification() {
            //Screen lock notifications
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),     //center
                Unmanaged.passUnretained(self).toOpaque(),     // observer
                displayStatusChangedCallback,     // callback
                "com.apple.springboard.lockcomplete" as CFString,     // event name
                nil,     // object
                .deliverImmediately)

        }
    func applicationWillTerminate(_ application: UIApplication){
//        if BoolValue.isFromCustomCameraDemoQues{
//            userDef.setValue(true, forKey: "donthaveques")
//            userDef.synchronize()
//        }
        
    }


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
