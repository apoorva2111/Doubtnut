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


class SignUpVC: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
       }
    
    @IBOutlet weak var viewEmail: RCustomView!
    @IBOutlet weak var tctEmailId: RCustomTextField!
    @IBOutlet weak var viewPhoneNumber: RCustomView!
    @IBOutlet weak var txtPhoneNumber: RCustomTextField!
    
    @IBOutlet weak var btnOutletGetVarCode: UIButton!
    var session_id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Do any additional setup after loading the view.
        txtPhoneNumber.delegate = self
        tctEmailId.delegate = self
        
    }
    
    
    
}
//MARK:- Custom Classes
extension SignUpVC{
    func validation(){
        self.view.endEditing(true)
        if tctEmailId.text == "" && txtPhoneNumber.text == ""{
            txtPhoneNumber.shake()
            tctEmailId.shake()
            self.showToast(message: "Please Enter Email id or Phone number")
            self.view.endEditing(true)
        }else if tctEmailId.text != ""{
            if !(tctEmailId.text!.isValidEmail()) {
                tctEmailId.shake()
                self.view.endEditing(true)
            }else{
                callApiGetOtpUsingEmail()
            }
        }else if txtPhoneNumber.text != ""{
            
            if !(txtPhoneNumber.text!.isPhoneNumber){
                txtPhoneNumber.shake()
                self.view.endEditing(true)
            }else{
               // let vc = FlowController().instantiateViewController(identifier: "GetOTPVC", storyBoard: "Main")
               // self.navigationController?.pushViewController(vc, animated: true)
                callApiGetOtpUsingPhoneNumber()
            }
        }
    }
}

extension SignUpVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if tctEmailId.text == ""{
            
            if txtPhoneNumber.text!.isPhoneNumber{
                viewPhoneNumber.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
                
            }else{
                viewPhoneNumber.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }
            
        }else{
            if tctEmailId.text!.isValidEmail() {
                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }else{
                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }
        }
        return true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tctEmailId{
            viewPhoneNumber.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            txtPhoneNumber.text = ""
            btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            btnOutletGetVarCode.layer.masksToBounds = true
        }else{
            viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            tctEmailId.text = ""
            btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            btnOutletGetVarCode.layer.masksToBounds = true

        }
    }
}
//MARK:- UIButton Action
extension SignUpVC {
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
    @IBAction func btnGetVarificationCodeAction(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- Call Webservice
extension SignUpVC {
   
    func callApiGetOtpUsingEmail(){
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let params:[String: Any] = ["phone_number":tctEmailId.text!,"login_method":"email_id"]

        var request = URLRequest(url: URL(string: "https://api.doubtnut.app/v4/student/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("847", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                
                OperationQueue.main.addOperation {

                if let meta = json["meta"] as? [String:AnyObject]{
                    let code = meta["code"] as! Int
                    if code == 200 {
                        if let data = json["data"] as? [String:AnyObject]{
                            let status = data["status"] as? String
                            if status == "FAILURE"{
                                self.showToast(message: "Something Went Wrong")
                            }else{
                                self.session_id = data["session_id"]as! String

                            }
                        }
                        let vc = FlowController().instantiateViewController(identifier: "GetOTPVC", storyBoard: "Main") as! GetOTPVC
                        vc.session_id = self.session_id
                            BaseApi.hideActivirtIndicator()
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }}
            } catch {
                print("error")
                OperationQueue.main.addOperation {
                BaseApi.hideActivirtIndicator()
                self.showToast(message: "Something Went Wrong")
                }
            }
        })

        task.resume()
    }
    
     func callApiGetOtpUsingPhoneNumber(){
         BaseApi.showActivityIndicator(icon: nil, text: "")

         let params:[String: Any] = ["phone_number":txtPhoneNumber.text!]

         var request = URLRequest(url: URL(string: "https://api.doubtnut.app/v4/student/login")!)
         request.httpMethod = "POST"
         request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
         request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
         request.addValue("847", forHTTPHeaderField: "version_code")
        // request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NjAyODk5ODIsImlhdCI6MTYxNTU3Mjk4NCwiZXhwIjoxNjc4NjQ0OTg0fQ._eOZrum06hEfpeGv9TXZe78xShOB3Dj9fU_V3ghdjpM", forHTTPHeaderField: "x-auth-token")
         request.addValue("US", forHTTPHeaderField: "country")

         let session = URLSession.shared
         let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
             print(response!)
             do {
                 let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                 print(json)
                 
                OperationQueue.main.addOperation {

                 if let meta = json["meta"] as? [String:AnyObject]{
                     let code = meta["code"] as! Int
                     if code == 200 {
                        
                            if let data = json["data"] as? [String:AnyObject]{
                                self.session_id = data["session_id"] as! String
                            }
                            let vc = FlowController().instantiateViewController(identifier: "GetOTPVC", storyBoard: "Main") as! GetOTPVC
                            vc.session_id = self.session_id
                            //   DispatchQueue.main.async {
                            BaseApi.hideActivirtIndicator()
                            self.navigationController?.pushViewController(vc, animated: true)
                            //    }
                        }
                        
                       
                     }
                 }
             } catch {
                 print("error")
                OperationQueue.main.addOperation {
                BaseApi.hideActivirtIndicator()
                self.showToast(message: "Something Went Wrong")
                }

             }
         })

         task.resume()
     }
}

//MARK:- Gmail Login

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
          
            let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
            self.navigationController?.pushViewController(vc, animated: true)
            
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
                let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
                self.navigationController?.pushViewController(vc, animated: true)

            }else{
//                APIClient.showAlertMessage(vc: self, titleStr: "Change Sign in with Apple settings for Hayti app.", messageStr: "Go to iPhone Settings > Apple Id > Password & Security > Apple ID logins > Hayti > Stop using Apple ID.")
             //   let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
             //   self.navigationController?.pushViewController(vc, animated: true)
                performExistingAccountSetupFlows()
            }
        }
    }
   
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        // Handle error.
    }
}

//MARK:- Facebook Login
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
                
                let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
                self.navigationController?.pushViewController(vc, animated: true)
                
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
