//
//  SignUpVC.swift
//  doubtnut
//
//  Created by Apoorva Gangrade on 04/03/21.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import Firebase
import FBSDKLoginKit
import SwiftKeychainWrapper

class SignUpVC: UIViewController, ASAuthorizationControllerPresentationContextProviding {
   

    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
       }
    
    @IBOutlet weak var viewEmail: RCustomView!
    @IBOutlet weak var tctEmailId: RCustomTextField!
    @IBOutlet weak var viewPhoneNumber: RCustomView!
    @IBOutlet weak var txtPhoneNumber: RCustomTextField!
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnOutletGetVarCode: UIButton!
    var session_id = ""
    @IBOutlet weak var appleLoginBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Do any additional setup after loading the view.
        txtPhoneNumber.delegate = self
        tctEmailId.delegate = self
        tctEmailId.becomeFirstResponder()
       GIDSignIn.sharedInstance().delegate = self

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tctEmailId.text = ""
        txtPhoneNumber.text = ""
        btnOutletGetVarCode.isUserInteractionEnabled = false
        viewPhoneNumber.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
        btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
        btnOutletGetVarCode.layer.masksToBounds = true
        viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
        btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
        btnOutletGetVarCode.layer.masksToBounds = true
    }
    
    
}
//MARK:- Custom Classes
extension SignUpVC{
    func validation(){

        self.view.endEditing(true)
        if tctEmailId.text == "" && txtPhoneNumber.text == ""{
            btnOutletGetVarCode.isUserInteractionEnabled = false
            txtPhoneNumber.shake()
            tctEmailId.shake()
            //self.showToast(message: "Please Enter Email id or Phone number")
            self.view.endEditing(true)
        }else if tctEmailId.text != ""{
            //if !(tctEmailId.text!.isValidEmail()) {
            if self.validateEmail(candidate: tctEmailId.text!){
                callApiGetOtpUsingEmail()
                
            }else{
                btnOutletGetVarCode.isUserInteractionEnabled = false
                tctEmailId.shake()
                
                self.view.endEditing(true)
            }
        }else if txtPhoneNumber.text != ""{
            
            if !(txtPhoneNumber.text!.isPhoneNumber){
                btnOutletGetVarCode.isUserInteractionEnabled = false
                txtPhoneNumber.shake()
                self.view.endEditing(true)
            }else{
                callApiGetOtpUsingPhoneNumber()
            }
        }
    }
}

extension SignUpVC : UITextFieldDelegate{
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        if tctEmailId.text == ""{
            
            if txtPhoneNumber.text!.isPhoneNumber{
                btnOutletGetVarCode.isUserInteractionEnabled = true
                viewPhoneNumber.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
                
            }else{
                btnOutletGetVarCode.isUserInteractionEnabled = false
                viewPhoneNumber.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }
            
        }else{
            if tctEmailId.text!.isValidEmail() {
//                if self.validateEmail(candidate: tctEmailId.text!){

                btnOutletGetVarCode.isUserInteractionEnabled = true
                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }else{
                btnOutletGetVarCode.isUserInteractionEnabled = false
                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let paste = UIPasteboard.general.string, tctEmailId.text == paste {
//           print("paste")
//        } else {
//           print("normal typing")
//        }

        if tctEmailId.text == ""{
            
            if txtPhoneNumber.text!.isPhoneNumber{
                btnOutletGetVarCode.isUserInteractionEnabled = true
                viewPhoneNumber.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
                
            }else{
                btnOutletGetVarCode.isUserInteractionEnabled = false
                viewPhoneNumber.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }
            
        }else{
            if tctEmailId.text!.isValidEmail() {
//                if self.validateEmail(candidate: tctEmailId.text!){

                btnOutletGetVarCode.isUserInteractionEnabled = true
                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }else{
                btnOutletGetVarCode.isUserInteractionEnabled = false
                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetVarCode.layer.masksToBounds = true
            }
        }
        textFieldDidEndEditing(tctEmailId)
        return true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnBackOutlet.isSelected = false
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
        self.view.endEditing(true)
        if(sender.tag == 10){
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        }
        else if(sender.tag == 20){
            let fbLoginManager = LoginManager()
            fbLoginManager.logIn(permissions: ["public_profile", "email", "name", "picture.type(large)"], from: self) { (result, error) in
                if let error = error {
                    print("Failed to login: \(error.localizedDescription)")
                    return
                }
                guard let accessToken = AccessToken.current else {
                    print("Failed to get access token")
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login by calling Firebase APIs
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                    print(user?.additionalUserInfo)
                    print(user?.credential)
                    // Present the main view
//                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
//                        UIApplication.shared.keyWindow?.rootViewController = viewController
//                        self.dismiss(animated: true, completion: nil)
//                    }
                    
                })
            }
        }else if(sender.tag == 30){
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
            
    
    @IBAction func btnGetVarificationCodeAction(_ sender: UIButton) {
        view.endEditing(true)
        validation()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            self.navigationController?.popViewController(animated: true)


        }else{
            sender.isSelected = true
            self.view.endEditing(true)

        }
    }
}
//MARK:- Call Webservice
extension SignUpVC {
   
    func callApiGetOtpUsingEmail(){
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        let params:[String: Any] = ["phone_number":tctEmailId.text!,"login_method":"email_id"]
        print(params)
        
        var request = URLRequest(url: URL(string: "https://api.doubtnut.app/v4/student/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("845", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                let param = BaseApi.showParam(json: params)
                let jsonString = BaseApi.checkResponse(json: json)
                OperationQueue.main.addOperation {
                    UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param),  URL:- https://api.doubtnut.app/v4/student/login", message: "Response: \(jsonString)     version_code: 845", buttons: ["OK","DISSMISS"], viewobj: self) { (btnClick) in
                        if btnClick == "OK"{
                            
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
                                    vc.emailID = self.tctEmailId.text!
                                    BaseApi.hideActivirtIndicator()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    
                                }else if code == 401{
                                    if let msg = meta["message"] as? String{
                                        BaseApi.hideActivirtIndicator()
                                        self.showToast(message: msg)
                                    }
                                }else{
                                    
                                    if let msg = meta["message"] as? String{
                                        BaseApi.hideActivirtIndicator()
                                        self.showToast(message: msg)
                                    }
                                    BaseApi.hideActivirtIndicator()
                                }
                            }
                        }else{
                            
                            BaseApi.hideActivirtIndicator()
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
    
     func callApiGetOtpUsingPhoneNumber(){
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let params:[String: Any] = ["phone_number":txtPhoneNumber.text!]

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
                let param = BaseApi.showParam(json: params)
                let jsonString = BaseApi.checkResponse(json: json)
               OperationQueue.main.addOperation {
                UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param), URL:- https://api.doubtnut.app/v4/student/login", message: "Response: \(jsonString)     version_code:- 847", buttons: ["OK","DISSMISS"], viewobj: self) { (clickBtn) in
                    if clickBtn == "OK"{
        
                if let meta = json["meta"] as? [String:AnyObject]{
                    let code = meta["code"] as! Int
                    if code == 200 {
                       
                      // OperationQueue.main.addOperation {
                           BaseApi.hideActivirtIndicator()
                           
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
                           vc.emailID = self.txtPhoneNumber.text!

                           self.navigationController?.pushViewController(vc, animated: true)
                         
                   
                       
                      
                    }else if code == 401{
                       if let msg = meta["message"] as? String{
                       BaseApi.hideActivirtIndicator()
                       self.showToast(message: msg)
                       }
                    }else{
                        
                        if let msg = meta["message"] as? String{
                        BaseApi.hideActivirtIndicator()
                        self.showToast(message: msg)
                        }
                        BaseApi.hideActivirtIndicator()


                    }
                }else{
                    OperationQueue.main.addOperation {
                        self.showToast(message: "Something Went Wrong")

                        BaseApi.hideActivirtIndicator()
                    }
                }
                    }else{
                        BaseApi.hideActivirtIndicator()

                    }
                }
               }
            } catch {
               OperationQueue.main.addOperation {
                   BaseApi.hideActivirtIndicator()

            }
                print("error")
            }
        })

        task.resume()
    }
    func loginWithSocialMedia(login_method:String,firebase_token:String,country_code:String,app_version: String,udid:String,gcm_reg_id:String,course:String,language:String,is_optin:Bool) {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let params:[String: Any] = ["login_method":login_method,"firebase_token":firebase_token]

        var request = URLRequest(url: URL(string: "https://api.doubtnut.app/v2/student/login-with-firebase")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("826", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                print(json)
                let param = BaseApi.showParam(json: params)
                let jsonString = BaseApi.showParam(json: json)
                OperationQueue.main.addOperation {
                    BaseApi.hideActivirtIndicator()
                    UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param),  URL:- https://api.doubtnut.app/v2/student/login-with-firebase", message: "Response: \(jsonString)     version_code:-826", buttons: ["OK","DISSMISS"], viewobj: self) { (clickBtn) in
                        if clickBtn == "Ok" {
                            BaseApi.hideActivirtIndicator()
                        }else{
                            
                        }

                    }
//                if let meta = json["meta"] as? [String:AnyObject]{
//                    let code = meta["code"] as! Int
////                    if code == 200 {
////                        if let data = json["data"] as? [String:AnyObject]{
////                            let status = data["status"] as? String
////                            if status == "FAILURE"{
////                                self.showToast(message: "Something Went Wrong")
////                            }else{
////                                self.session_id = data["session_id"]as! String
////
////                            }
////                        }
////                        let vc = FlowController().instantiateViewController(identifier: "GetOTPVC", storyBoard: "Main") as! GetOTPVC
////                        vc.session_id = self.session_id
////                        vc.emailID = self.tctEmailId.text!
////                            BaseApi.hideActivirtIndicator()
////                        self.navigationController?.pushViewController(vc, animated: true)
////
////                    }
//                }
                    
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
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        // Check for sign in error
        if let error = error {
            BaseApi.hideActivirtIndicator()
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // Get credential object using Google ID token and Google access token
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
            }
                
            // Post notification after user successfully sign in
//            print(authResult?.user.displayName)
//            print(authentication.accessToken)
//            print(authResult?.user.email)
            print(authResult?.credential)
            let vesrion = Bundle.main.versionNumber
            let deviceID = UIDevice.current.identifierForVendor!.uuidString

            self.loginWithSocialMedia(login_method: "google", firebase_token: authentication.accessToken, country_code: "91", app_version: vesrion, udid: deviceID, gcm_reg_id: "cMCCj_yFQ8mjuWR_mi1lBm:APA91bFOY4O3cwx0yZeVQYbv4qhPfmX9sngjDgG8r-rKK8jbXyzE2Dy5gVgUEqZTl0jJE5e2XbyPgQ_ZwDSdQohBKrPy846bJTpZf6oC-ILmjZeCnGKSMkTQqt18g7W4oJcI9jIH_nhc", course: "", language: "", is_optin: true)
        }

    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!)
//    {
//        if let _ = error {
//            //print("errrrr = \(error.localizedDescription)")
//        } else {
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let  email = user.profile.email
//
//            let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
//            self.navigationController?.pushViewController(vc, animated: true)
//
//            print(givenName)
//            print(familyName)
//            print(email)
//
////            var tokan = ""
////            if let fcmToken = userDef.object(forKey: "fcmToken") as? String{
////                tokan = fcmToken
////                //APIClient.showAlertMessage(vc: self, titleStr: "", messageStr: tokan)
////            }
////
//
////            APIClient.callLoginapi(email: email!, firstName: givenName!, lastName: familyName!, address: address, city: city, country: country, postalcode: postalcode, profile: "", appname: Endpoints.Environment.appName, regsource: "google", tokens: tokan) { (loginModel) in
////
////                //save user model in userdefault and navigate to home
////
////                OperationQueue.main.addOperation {
////                    let encoder = JSONEncoder()
////                    if let encoded = try? encoder.encode(loginModel.user_info!) {
////                        userDef.set(encoded, forKey: "userInfo")
////                        userDef.set("google", forKey: "socela_media")
////                    }
////
////                    self.dismiss(animated: true) {
////                        if let userInfo = userDef.object(forKey: "userInfo") as? Data {
////                            let decoder = JSONDecoder()
////                            if let userM = try? decoder.decode(User_info.self, from: userInfo) {
////                                userGlobal = userM
////                                self.vc.viewWillAppear(true)
////                            }
////                        }
////                    }
////                }
////
////
////            }
//        }
//    }
//
//    // Present a view that prompts the user to sign in with Google
//    func sign(_ signIn: GIDSignIn!,
//              present viewController: UIViewController!) {
//        // customLoader.hide()
//        self.present(viewController, animated: false, completion: nil)
//    }
//
//    // Dismiss the "Sign in with Google" view
//    func sign(_ signIn: GIDSignIn!,
//              dismiss viewController: UIViewController!) {
//        self.dismiss(animated: false, completion: nil)
//    }
//
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
//              withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }
//
}

extension SignUpVC : ASAuthorizationControllerDelegate {
    
    func createAppleLoginButton(){
        
//        let authorizationButton = ASAuthorizationAppleIDButton()
//
//        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
//
//        self.viewAppleLogin.addSubview(authorizationButton)
//
//        NSLayoutConstraint.activate([
//            authorizationButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.viewAppleLogin.centerXAnchor, multiplier: 1),
//            authorizationButton.centerYAnchor.constraint(equalToSystemSpacingBelow: self.viewAppleLogin.centerYAnchor, multiplier: 1),
//            authorizationButton.heightAnchor.constraint(equalToConstant: 65),
//            authorizationButton.widthAnchor.constraint(equalToConstant: self.viewAppleLogin.frame.width)
//        ])
//
        self.appleLoginBtn.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)

    }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
    }
        
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }


    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        //need to save details in firsttime
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let _ = appleIDCredential.user

            if let email = appleIDCredential.email {

                let fullName = appleIDCredential.fullName
                let Firstname = (fullName?.givenName)!
                let Lastname = (fullName?.familyName)!

                
                KeychainWrapper.standard.set(appleIDCredential, forKey: "appleCred")
                
                self.getCredentialsFomLoginAndCallApi(strFrstname: Firstname, strLastname: Lastname, strEmail: email)

            }

            else{
                
                
                if let appleCred = KeychainWrapper.standard.object(forKey: "appleCred") as? ASAuthorizationAppleIDCredential{
                    
                    let email = appleCred.email
                    let fullName = appleCred.fullName
                    let Firstname = (fullName?.givenName)!
                    let Lastname = (fullName?.familyName)!

                    self.getCredentialsFomLoginAndCallApi(strFrstname: Firstname, strLastname: Lastname, strEmail: email)
                }
                       
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        // Handle error.
    }
    
    func getCredentialsFomLoginAndCallApi(strFrstname: String?, strLastname: String?, strEmail: String?){
        

        var tokan = ""
        if let fcmToken = userDef.object(forKey: "fcmToken") as? String{
            tokan = fcmToken
            //APIClient.showAlertMessage(vc: self, titleStr: "", messageStr: tokan)
        }

        
        var deviceID = ""
        if let device_token = userDef.object(forKey: "device_token") as? String{
            deviceID = device_token
        }


    }
    
    


}

//MARK:- Facebook Login
extension SignUpVC {
    
    
    
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
