//
//  LoginwithPincode.swift
//  doubtnut
//
//  Created by Apoorva Gangrade on 04/03/21.
//

import UIKit

class LoginwithPincode: UIViewController {
   
    @IBOutlet weak var viewEmailAndPhone: RCustomView!
    
    @IBOutlet weak var txtEmail: RCustomTextField!
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var viewPin: RCustomView!
    @IBOutlet weak var txtEnterPin: RCustomTextField!
    @IBOutlet weak var btnLoginOutlet: RCustomButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtEmail.delegate = self
        txtEnterPin.delegate = self
        txtEmail.becomeFirstResponder()
        
        
        //self.callLoginApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtEmail.text = ""
        txtEnterPin.text = ""
    }
}

//MARK:- Custom Classes
extension LoginwithPincode{
    func validation() {
        if txtEmail.text == "" && txtEnterPin.text == ""{
            self.showToast(message: "Please Enter Your Email ID or Phone Number and PIN")
            txtEmail.shake()
            txtEnterPin.shake()
        }else if txtEmail.text == ""{
            self.showToast(message: "Please Enter Your Email ID or Phone Number")
            txtEmail.shake()
        }else if txtEnterPin.text == ""{
            self.showToast(message: "Please Enter Your 4 Digit PIN")
            txtEnterPin.shake()
        }else{
            view.endEditing(true)
            WenserviceCallForLogin()
        }
    }

}
//MARK:- API Call
extension LoginwithPincode{
    func WenserviceCallForLogin() {
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let parameters = ["identifier":txtEmail.text,"pin":txtEnterPin.text]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v1/student/login-with-pin")! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)

                   
                    if let meta = json["meta"] as? [String:AnyObject]{
                        let code = meta["code"] as! Int
                        if code == 200 {
                            // create the alert
                            OperationQueue.main.addOperation {
                                BaseApi.hideActivirtIndicator()
                                if let data = json["data"] as? [String:AnyObject]{
                                    let token = data["token"] as! String
                                    userDef.set(token, forKey: "Auth_token")
                                    userDef.synchronize()
                                }
//                                if userDef.value(forKey: UserDefaultKey.firsTime) == nil{
//
//                                    userDef.setValue("isFristTime", forKey: UserDefaultKey.firsTime)
//                                    userDef.setValue(0, forKey: UserDefaultKey.cameraCount)
//                                    userDef.synchronize()
//
//                                    userDef.synchronize()
//                                    let vc = FlowController().instantiateViewController(identifier: "CustomCameraVC", storyBoard: "Home")
//                                    self.navigationController?.pushViewController(vc, animated: false)
//
//                                }else{
//                                let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
//
                                
                                

                                userDef.setValue(0, forKey: UserDefaultKey.cameraCount)
                                
                                if var count = userDef.value(forKey: "LoginCount") as? Int{
                                    count += 1
                                    userDef.setValue(count, forKey: "LoginCount")
                                    userDef.synchronize()
                                    
                                    if count > 5{
                                        let vc = FlowController().instantiateViewController(identifier: "navDash", storyBoard: "Home") as! UINavigationController
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: false, completion: nil)                                    }else{
                                        let vc = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home") as! UINavigationController
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: false, completion: nil)
                                    }
                                    

                                }else{
                                    userDef.setValue(1, forKey: "LoginCount")
                                    userDef.synchronize()
                                 
                                    let vc = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home") as! UINavigationController
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: false, completion: nil)
                                }
                                

                              
}
                        }else if code == 403{
                            OperationQueue.main.addOperation {
                                BaseApi.hideActivirtIndicator()

                            if let data = json["data"] as? [String:AnyObject]{
                                let strMsg = data["message"] as! String
                                self.showToast(message:strMsg)
                            }
                            }
                            
                        }else{
                            OperationQueue.main.addOperation {
                                BaseApi.hideActivirtIndicator()
                                self.showToast(message: "Please Enter Correct Phone Number Or Email Id and PIN")
                            }
                            
                        }
                    }
            
                    // handle json..
                        
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
//MARK:- Textfeild Delegate
extension LoginwithPincode : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      //  if txtEmail.text!.isValidEmail() {
        if self.validateEmail(candidate: txtEmail.text!){

            viewEmailAndPhone.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
        }else{
            viewEmailAndPhone.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
           
        if txtEmail.text!.isPhoneNumber {
                viewEmailAndPhone.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            }else{
                viewEmailAndPhone.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            }
        }
       
       
        if textField == txtEnterPin{
        let maxLength = 4
           let currentString: NSString = (textField.text ?? "") as NSString
           let newString: NSString =
               currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length > 4{

                textField.shake()
            }else{
                if newString.length == 4 {
                    viewPin.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                    btnLoginOutlet.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                }else{
                    viewPin.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                    btnLoginOutlet.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                }
            }
           return newString.length <= maxLength
        }
            return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnBackOutlet.isSelected = false
        
    }
}
//MARK:- Buton Action
extension LoginwithPincode{
    @IBAction func btnLoginAction(_ sender: Any) {
        self.view.endEditing(true)

        validation()
    }
    
    @IBAction func loginViewCOdeAction(_ sender: Any) {
        self.view.endEditing(true)
        let vc = FlowController().instantiateViewController(identifier: "LoginWithCodeVC", storyBoard: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
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
