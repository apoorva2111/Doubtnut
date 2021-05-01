//
//  LoginVC.swift
//  doubtnut
//
//  Created by Apoorva Gangrade on 04/03/21.
//

import UIKit

class LoginWithCodeVC: UIViewController {

   
    @IBOutlet weak var viewEmail: RCustomView!
    
       @IBOutlet weak var btnOutletGetOTP: RCustomButton!
    
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var txtEmail: RCustomTextField!
    
    var session_id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtEmail.becomeFirstResponder()
        // Do any additional setup after loading the view.

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtEmail.text = ""
    }
    
}
extension LoginWithCodeVC:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtEmail.text?.isNumeric == true{
            if txtEmail.text!.isPhoneNumber {
                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                
            }else{
                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                
            }
        }else{
           // if txtEmail.text!.isValidEmail() {
            if self.validateEmail(candidate: txtEmail.text!){

                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            }else{
                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            }
        }
       
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtEmail.text?.isNumeric == true{
            if txtEmail.text!.isPhoneNumber {
                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                
            }else{
                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                
            }
        }else{
            // if txtEmail.text!.isValidEmail() {
             if self.validateEmail(candidate: txtEmail.text!){

                 viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                 btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
             }else{
                 viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                 btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
             }
         }
      
        
        
       // let decimalCharacters = CharacterSet.decimalDigits
        
       // let decimalRange = txtEmail.text!.rangeOfCharacter(from: decimalCharacters)
        
//        if decimalRange != nil {
//            if txtEmail.text!.isPhoneNumber {
//                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
//                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
//
//            }else{
//                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
//                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
//
//            }
//        }else{
           // if txtEmail.text!.isValidEmail() {
//            if self.validateEmail(candidate: txtEmail.text!){
//
//                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
//                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
//            }else{
//                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
//                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
//            }
//        }
    textFieldDidEndEditing(txtEmail)
            return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    btnBackOutlet.isSelected = false
    }
}
extension String {
   var isNumeric: Bool {
     return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
   }
}
//MARK:- Call Webservice
extension LoginWithCodeVC {
   
    func callApiGetOtpUsingEmail(){
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let params:[String: Any] = ["phone_number":txtEmail.text!,"login_method":"email_id"]

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
                            BaseApi.hideActivirtIndicator()
                            if let data = json["data"] as? [String:AnyObject]{
                                let status = data["status"] as? String
                                if status == "FAILURE"{
                                    self.showToast(message: "Something Went Wrong")
                                }else{
                                    self.session_id = data["session_id"]as! String
                                    
                                }
                            }
                            let vc = FlowController().instantiateViewController(identifier: "LoginGotOTPVC", storyBoard: "Main") as! LoginGotOTPVC
                            vc.session_id = self.session_id
                            vc.emailID = self.txtEmail.text!
                            BaseApi.hideActivirtIndicator()
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else if code == 401{
                            BaseApi.hideActivirtIndicator()
                            self.showToast(message: "Too many OTP Requests")

                        }else if code == 500 {
                            self.showToast(message: "Internal Server Error")

                            BaseApi.hideActivirtIndicator()
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
    
     func callApiGetOtpUsingPhoneNumber(){
         BaseApi.showActivityIndicator(icon: nil, text: "")

         let params:[String: Any] = ["phone_number":txtEmail.text!]

         var request = URLRequest(url: URL(string: "https://api.doubtnut.app/v4/student/login")!)
         request.httpMethod = "POST"
         request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
         request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
         request.addValue("847", forHTTPHeaderField: "version_code")
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

                            let vc = FlowController().instantiateViewController(identifier: "LoginGotOTPVC", storyBoard: "Main") as! LoginGotOTPVC
                            vc.session_id = self.session_id
                            //   DispatchQueue.main.async {
                            self.navigationController?.pushViewController(vc, animated: true)
                            //    }
                      //  }
                        
                       
                     }else if code == 401{
                        if let msg = meta["message"] as? String{
                        BaseApi.hideActivirtIndicator()
                        self.showToast(message: msg)
                        }
                     }else if code == 500 {
                        self.showToast(message: "Internal Server Error")

                        BaseApi.hideActivirtIndicator()
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
}

extension LoginWithCodeVC{
    @IBAction func btnBackAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            self.navigationController?.popViewController(animated: true)

        }else{
            sender.isSelected =  true
            self.view.endEditing(true)
            }
    }
    @IBAction func btnGetOtpAction(_ sender: Any) {
        self.view.endEditing(true)
        if txtEmail.text == "" {
            self.txtEmail.shake()
            self.showToast(message: "Please enter Email id or Phone Number")
        }else{
            if txtEmail.text?.isNumeric == true{
                callApiGetOtpUsingPhoneNumber()
            }else{
                callApiGetOtpUsingEmail()
            }
        }
    }
}
