//
//  LoginGotOTPVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 16/03/21.
//

import UIKit

class LoginGotOTPVC: UIViewController {
    var session_id = ""
    @IBOutlet weak var lblOtpLine1: UILabel!
    @IBOutlet weak var lblOtpLine2: UILabel!
    @IBOutlet weak var lblOtpLine3: UILabel!
    @IBOutlet weak var lblOtpLine4: UILabel!
    @IBOutlet weak var txtOtp1: RCustomTextField!
    @IBOutlet weak var txtOtp2: RCustomTextField!
    @IBOutlet weak var txtOtp3: RCustomTextField!
    @IBOutlet weak var txtOtp4: RCustomTextField!
    @IBOutlet weak var btnOutletSubmit: RCustomButton!
    @IBOutlet weak var lblViderification: UILabel!
    @IBOutlet weak var lblTimmer: UILabel!
    @IBOutlet weak var btnBackOutlet: UIButton!
   
    
    var emailID = ""
    var counter = 30
    var isStopToast = false
    var timer:DispatchSourceTimer?//Timer?
    
    @IBAction func btnResendCodeAction(_ sender: UIButton) {
        stopTimer()
        view.endEditing(true)
        if self.validateEmail(candidate: emailID){
            callApiGetOtpUsingEmail()

        }else  if !(emailID.isPhoneNumber){
        }else{
            callApiGetOtpUsingPhoneNumber()
        }
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
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        validation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOtp1.becomeFirstResponder()
        lblViderification.text = "Verification Code has been sent to " + emailID
        
        setView()
        createTimer()
        startTimer()
        if self.validateEmail(candidate: emailID){
            counter = 300
        }else if !(emailID.isPhoneNumber){
        }else{
            counter = 60
        }
        
    }
    func createTimer() {
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1.0)

        timer?.setEventHandler { [weak self] in      // assuming you're referencing `self` in here, use `weak` to avoid strong reference cycles
            // do something
            self?.updateCounter()
        }

        // note, timer is not yet started; you have to call `timer?.resume()`
    }

    func startTimer() {
        timer?.resume()
    }

    func pauseTiemr() {
        timer?.suspend()
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
     func updateCounter() {
        //example functionality
        
        lblTimmer.textColor = #colorLiteral(red: 0.6211201549, green: 0.6355717182, blue: 0.6358628273, alpha: 1)
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            lblTimmer.text =  "\(counter)" + "s Resend Code"
            counter -= 1
        }else{
            print("\(counter) seconds to the end of the world")
            lblTimmer.text =  "\(counter)" + "s Resend Code"

        }
        if counter == 0{
            if isStopToast{
                
            }else{
                self.showToast(message: "Your OTP is Expire Please Resend")
                self.isStopToast = true
            }
            lblTimmer.text = "Resend Code"
            lblTimmer.textColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            
        }
    }

    
}
//MARK:- Custom Classes
extension LoginGotOTPVC{
    func setView() {
        txtOtp1.delegate = self
        txtOtp2.delegate = self
        txtOtp3.delegate = self
        txtOtp4.delegate = self
        txtOtp1.valueType = .onlyNumbers
        txtOtp2.valueType = .onlyNumbers
        txtOtp3.valueType = .onlyNumbers
        txtOtp4.valueType = .onlyNumbers
        
        txtOtp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
    }
    
    func validation(){
        self.view.endEditing(true)
        if txtOtp1.text == "" && txtOtp2.text == "" && txtOtp3.text == "" && txtOtp4.text == ""{
                txtOtp1.shake()
                txtOtp2.shake()
                txtOtp3.shake()
                txtOtp4.shake()
                self.showToast(message: "Please Enter Validation Code or Set Your 4 Digit PIN")
                
            }else if txtOtp1.text == "" || txtOtp2.text == "" || txtOtp3.text == "" || txtOtp4.text == "" {
                txtOtp1.shake()
                txtOtp2.shake()
                txtOtp3.shake()
                txtOtp4.shake()
                self.showToast(message: "Please Enter 4 Digit Validation Code or Set Your 4 Digit PIN")
                
            }else{
                let strOTP = txtOtp1.text! + txtOtp2.text! + txtOtp3.text! + txtOtp4.text!
                if counter == 0{
                    self.showToast(message: "Your OTP is Expire Please Resend")
                }else{
                webserviceCallVerifyOTP(strOtp:strOTP)
                }
            }
            
        }
        
    }

//MARK:- Textfeild Delegate
extension LoginGotOTPVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnBackOutlet.isSelected = false
        if textField == txtOtp1 || textField == txtOtp2 || textField == txtOtp3 || textField == txtOtp4{
            btnOutletSubmit.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            btnOutletSubmit.layer.masksToBounds = true
        }else{
            lblOtpLine1.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            lblOtpLine2.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            lblOtpLine3.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            lblOtpLine4.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)

            txtOtp1.text = ""
            txtOtp2.text = ""
            txtOtp3.text = ""
            txtOtp4.text = ""

            btnOutletSubmit.layer.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            btnOutletSubmit.layer.masksToBounds = true
        }
    }
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        if text!.count >= 1{
            
            switch textField{
            case txtOtp1:
                txtOtp2.becomeFirstResponder()
                lblOtpLine1.backgroundColor=#colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            case txtOtp2:
                txtOtp3.becomeFirstResponder()
                lblOtpLine2.backgroundColor=#colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)

            case txtOtp3:
                txtOtp4.becomeFirstResponder()
                lblOtpLine3.backgroundColor=#colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)

            case txtOtp4:
                txtOtp4.resignFirstResponder()
                lblOtpLine4.backgroundColor=#colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletSubmit.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
               
            default:
                break
            }
        }else{
            switch textField{
            case txtOtp4:
                txtOtp3.becomeFirstResponder()
                lblOtpLine4.backgroundColor=#colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)
                btnOutletSubmit.backgroundColor = #colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)

            case txtOtp3:
                txtOtp2.becomeFirstResponder()
                lblOtpLine3.backgroundColor=#colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)

            case txtOtp2:
                txtOtp1.becomeFirstResponder()
                lblOtpLine2.backgroundColor=#colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)

            case txtOtp1:
                txtOtp1.resignFirstResponder()
                lblOtpLine1.backgroundColor=#colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)

               
            default:
                break
            }
        }
        
    }
}
//MARK:- Webservice Call
extension LoginGotOTPVC{
    func webserviceCallVerifyOTP(strOtp: String){
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
       let parameters = ["otp":strOtp,"session_id":session_id]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v4/student/verify")! //change the url

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
                    OperationQueue.main.addOperation {

                    if let meta = json["meta"] as? [String:AnyObject]{
                        let code = meta["code"] as! Int
                        if code == 200 {
                            if let data = json["data"] as? [String:AnyObject]{
                                if let status = data["status"]{
                                    if status as! String == "FAILURE"{
                                        BaseApi.hideActivirtIndicator()
                                        self.showToast(message: "Please Enter Correct Verification Code")
                                        return
                                    }
                                }
                                
                                
                                let token = data["token"] as! String
                                userDef.set(token, forKey: "Auth_token")
                                userDef.synchronize()
                                
                                userDef.setValue(0, forKey: UserDefaultKey.cameraCount)
                                userDef.synchronize()
                            }
                                BaseApi.hideActivirtIndicator()
                                
                            SettingValue.LoginCount += 1

                                // add an action (button)
//                            if SettingValue.LoginCount >= 5{
//                                let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home") as! DashboardVC
//                                self.navigationController?.pushViewController(vc, animated: false)
//
//                            }else{
                                let vc = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home") as! UINavigationController
                                self.navigationController?.pushViewController(vc, animated: false)
                           // }
                            }
                          //  }
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
    func callApiGetOtpUsingEmail(){
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let params:[String: Any] = ["phone_number":emailID,"login_method":"email_id"]

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
                        BaseApi.hideActivirtIndicator()

                        self.showToast(message: "OTP Successully Sent on Your Email Id")
                        self.counter = 300
                        self.createTimer()
                        self.startTimer()

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

        let params:[String: Any] = ["phone_number":emailID]

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
                        self.showToast(message: "OTP Successully Sent on Your Mobile")
                        self.counter = 60
                        self.createTimer()

                        self.startTimer()
                      
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
