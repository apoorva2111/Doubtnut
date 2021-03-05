//
//  SignUpVC.swift
//  doubtnut
//
//  Created by Apoorva Gangrade on 04/03/21.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit


class SignUpVC: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickOnSocialMediaLogin(_ sender: UIButton)
    {
        if(sender.tag == 10){
            GIDSignIn.sharedInstance().signIn()
        }
        else if(sender.tag == 20){
            facebookSignup()
        }
        else if(sender.tag == 30){
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
}


extension SignUpVC : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!)
    {
        if let _ = error {
            //print("errrrr = \(error.localizedDescription)")
        } else {
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let  email = user.profile.email
            
            print(givenName)
            print(familyName)
            print(email)
            
//            var tokan = ""
//            if let fcmToken = userDef.object(forKey: "fcmToken") as? String{
//                tokan = fcmToken
//                //APIClient.showAlertMessage(vc: self, titleStr: "", messageStr: tokan)
//            }
//
            
//            APIClient.callLoginapi(email: email!, firstName: givenName!, lastName: familyName!, address: address, city: city, country: country, postalcode: postalcode, profile: "", appname: Endpoints.Environment.appName, regsource: "google", tokens: tokan) { (loginModel) in
//
//                //save user model in userdefault and navigate to home
//
//                OperationQueue.main.addOperation {
//                    let encoder = JSONEncoder()
//                    if let encoded = try? encoder.encode(loginModel.user_info!) {
//                        userDef.set(encoded, forKey: "userInfo")
//                        userDef.set("google", forKey: "socela_media")
//                    }
//
//                    self.dismiss(animated: true) {
//                        if let userInfo = userDef.object(forKey: "userInfo") as? Data {
//                            let decoder = JSONDecoder()
//                            if let userM = try? decoder.decode(User_info.self, from: userInfo) {
//                                userGlobal = userM
//                                self.vc.viewWillAppear(true)
//                            }
//                        }
//                    }
//                }
//
//
//            }
        }
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        // customLoader.hide()
        self.present(viewController, animated: false, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}

extension SignUpVC : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        //need to save details in firsttime
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let _ = appleIDCredential.user
            
            if let email = appleIDCredential.email {
                
                let fullName = appleIDCredential.fullName
                let Firstname = (fullName?.givenName)!
                let Lastname = (fullName?.familyName)!
                
//                var tokan = ""
//                if let fcmToken = userDef.object(forKey: "fcmToken") as? String{
//                    tokan = fcmToken
//                    //APIClient.showAlertMessage(vc: self, titleStr: "", messageStr: tokan)
//                }
                
//                APIClient.callLoginapi(email: email, firstName: Firstname, lastName: Lastname, address: address, city: self.city, country: self.country, postalcode: self.postalcode, profile: "", appname: Endpoints.Environment.appName, regsource: "apple", tokens: tokan) { (loginModel) in
//
//                    //save user model in userdefault and navigate to home
//
//                    OperationQueue.main.addOperation {
//                        let encoder = JSONEncoder()
//                        if let encoded = try? encoder.encode(loginModel.user_info!) {
//                            userDef.set(encoded, forKey: "userInfo")
//                            userDef.set("apple", forKey: "socela_media")
//                        }
//
//                        if let userInfo = userDef.object(forKey: "userInfo") as? Data {
//                            let decoder = JSONDecoder()
//                            if let userM = try? decoder.decode(User_info.self, from: userInfo) {
//                                userGlobal = userM
//                                let home = self.storyboard?.instantiateViewController(identifier: "homeViewController") as! homeViewController
//                                self.navigationController?.pushViewController(home, animated: true)
//                            }
//                        }
//                    }
//                }
            }
            
            else{
//                APIClient.showAlertMessage(vc: self, titleStr: "Change Sign in with Apple settings for Hayti app.", messageStr: "Go to iPhone Settings > Apple Id > Password & Security > Apple ID logins > Hayti > Stop using Apple ID.")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        // Handle error.
    }
}

extension SignUpVC {
    
    func facebookSignup()
    {
        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["email"], from: self, handler: { (result, error) -> Void in
            
            if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.returnUserData()
                }
                else {
                    print("fbbbbb = \(fbloginresult)")
                }
            }
        })
    }
    
    func returnUserData() {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, name, picture.type(large), email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // print("\n\n Error: \(String(describing: error))")
            } else {
                let resultDic = result as! NSDictionary
                print("\n\n  fetched user: \(String(describing: resultDic))")
                
                var fname = ""
                var lname = ""
                
                if let name = resultDic.value(forKey:"name")! as? String{
                    let fullNameArr = name.components(separatedBy: " ")
                    fname = fullNameArr[0]
                    lname = fullNameArr[1]
                }
                let email = resultDic.value(forKey:"email")! as! String
                
               
                
//                var tokan = ""
//                if let fcmToken = userDef.object(forKey: "fcmToken") as? String{
//                    tokan = fcmToken
//                    //APIClient.showAlertMessage(vc: self, titleStr: "", messageStr: tokan)
//                }
                
                
//                APIClient.callLoginapi(email: email, firstName: fname, lastName: lname, address: self.address,city:self.city, country: self.country, postalcode: self.postalcode, profile: "", appname: Endpoints.Environment.appName, regsource: "facebook", tokens: tokan) { (loginModel) in
//
//                    //save user model in userdefault and navigate to home
//                    OperationQueue.main.addOperation {
//
//                        let encoder = JSONEncoder()
//                        if let encoded = try? encoder.encode(loginModel.user_info!) {
//                            userDef.set(encoded, forKey: "userInfo")
//                            userDef.set("facebook", forKey: "socela_media")
//                        }
//                        self.dismiss(animated: true) {
//                            if let userInfo = userDef.object(forKey: "userInfo") as? Data {
//                                let decoder = JSONDecoder()
//                                if let userM = try? decoder.decode(User_info.self, from: userInfo) {
//                                    userGlobal = userM
//                                    self.vc.viewWillAppear(true)
//                                }
//                            }
//                        }
//                    }
//                }
            }
        })
    }
}
