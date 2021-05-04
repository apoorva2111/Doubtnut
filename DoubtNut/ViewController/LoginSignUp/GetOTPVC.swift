//
//  GetOTPVC.swift
//  doubtnut
//
//  Created by Apoorva Gangrade on 04/03/21.
//

import UIKit

class GetOTPVC: UIViewController {

    @IBOutlet weak var lblVeriCodeEmail: UILabel!
    @IBOutlet weak var lblOtpLine1: UILabel!
    @IBOutlet weak var lblOtpLine2: UILabel!
    @IBOutlet weak var lblOtpLine3: UILabel!
    @IBOutlet weak var lblOtpLine4: UILabel!
    @IBOutlet weak var txtOtp1: RCustomTextField!
    @IBOutlet weak var txtOtp2: RCustomTextField!
    @IBOutlet weak var txtOtp3: RCustomTextField!
    @IBOutlet weak var txtOtp4: RCustomTextField!

    @IBOutlet weak var viewSetPin: RCustomView!
    @IBOutlet weak var viewReEnterPin: RCustomView!
    @IBOutlet weak var txtSetPin: RCustomTextField!
    @IBOutlet weak var txtReenterPin: RCustomTextField!
    @IBOutlet weak var btnOutletSubmit: RCustomButton!
  
    @IBOutlet weak var btnBackOutlet: UIButton!
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
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        self.view.endEditing(true)
        validation()
    }
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            stopTimer()

            self.navigationController?.popViewController(animated: true)

        }else{
            sender.isSelected = true
            self.view.endEditing(true)
        }
       
    }
    var isStopToast = false
    var session_id = ""
    var emailID = ""
    var counter = 30
    var timer:DispatchSourceTimer?//Timer?

    var isSetPin = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        // Do any additional setup after loading the view.
        print(session_id)
        lblVeriCodeEmail.text = "Verification Code has been sent to " + emailID
        txtOtp1.becomeFirstResponder()
        createTimer()
        startTimer()
        
        if self.validateEmail(candidate: emailID){
            counter = 300
        }else  if !(emailID.isPhoneNumber){
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
        
        lblTimer.textColor = #colorLiteral(red: 0.6211201549, green: 0.6355717182, blue: 0.6358628273, alpha: 1)
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            lblTimer.text =  "\(counter)" + "s Resend Code"
            counter -= 1
        }else{
            print("\(counter) seconds to the end of the world")
            lblTimer.text =  "\(counter)" + "s Resend Code"

        }
        if counter == 0{
            if isStopToast{
                
            }else{
                self.showToast(message: "Your OTP is Expire Please Resend")
                self.isStopToast = true
            }
            lblTimer.text = "Resend Code"
            lblTimer.textColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            
        }
    }

}
//MARK:- Webservice Call
extension GetOTPVC{
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
                            /**/
                            BaseApi.hideActivirtIndicator()
                            
                            if let data = json["data"] as? [String:AnyObject]{
                                if let status = data["status"]{
                                    if status as! String == "FAILURE"{
                                        self.showToast(message: "Please Enter Correct Verification Code")
                                        return
                                    }
                                }
                                let token = data["token"] as! String
                                userDef.set(token, forKey: "Auth_token")
                                userDef.synchronize()
                                
                            }
                            userDef.setValue(0, forKey: UserDefaultKey.cameraCount)
                            userDef.synchronize()
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

                               
                                
                        
                        }else if code == 401{
                            BaseApi.hideActivirtIndicator()
                            let message = meta["message"] as! String
                            self.showToast(message: message)

                        }
                        else{
                            BaseApi.hideActivirtIndicator()
                            self.showToast(message: "Something Went Wrong")
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
    func webserviceCallStorePin(strPIN: String){
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
       let parameters = ["pin":strPIN]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v1/student/store-pin")! //change the url

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
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        
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
                    
                    OperationQueue.main.addOperation {

                    if let meta = json["meta"] as? [String:AnyObject]{
                        let code = meta["code"] as! Int
                        if code == 200 {
                                self.showToast(message: "Pin Inserted")

                            BaseApi.hideActivirtIndicator()
                            let vc = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home") as! UINavigationController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: false, completion: nil)
                         
                        }else if code == 403{
                            if let data = json["data"] as? [String:AnyObject]{
                                let msg = data["message"] as? String
                                self.showToast(message: msg!)
                            }
                            BaseApi.hideActivirtIndicator()

                        }
                        else{
                            self.showToast(message: "Try With Another Number")

                            BaseApi.hideActivirtIndicator()
                        }
                        }
                    }
                    /**/
                    // handle json...
                }
            } catch let error {
                self.showToast(message: "Something Went Wrong")

                BaseApi.hideActivirtIndicator()

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
//MARK:- Custom Classes
extension GetOTPVC{
    func setView() {
        txtOtp1.delegate = self
        txtOtp2.delegate = self
        txtOtp3.delegate = self
        txtOtp4.delegate = self
        txtSetPin.delegate = self
        txtReenterPin.delegate = self
        txtOtp1.valueType = .onlyNumbers
        txtOtp2.valueType = .onlyNumbers
        txtOtp3.valueType = .onlyNumbers
        txtOtp4.valueType = .onlyNumbers
        txtReenterPin.valueType = .onlyNumbers
        txtSetPin.valueType = .onlyNumbers
        
        txtOtp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtSetPin.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtReenterPin.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)

    }
    
    func validation(){
        self.view.endEditing(true)
        if isSetPin{
            if txtSetPin.text == "" && txtReenterPin.text == ""{
           
                self.showToast(message: "Please Your Enter 4 Digit PIN")
           
            }else if txtSetPin.text != "" && txtReenterPin.text != ""{
               
                if txtSetPin.text!.count > 4 || txtReenterPin.text!.count > 4 {
                    self.showToast(message: "Please Enter 4 Digit PIN")
                }else if txtSetPin.text != txtReenterPin.text{
                    txtSetPin.shake()
                    txtReenterPin.shake()
                    self.showToast(message: "Set PIN and Reset PIN is Not Match")

                }else{
                    if isSetPin{
                        webserviceCallStorePin(strPIN: txtSetPin.text!)

                    }else{
                        
                    }
                }
            }
        }else{
            if txtOtp1.text == "" && txtOtp2.text == "" && txtOtp3.text == "" && txtOtp4.text == ""{
                txtOtp1.shake()
                txtOtp2.shake()
                txtOtp3.shake()
                txtOtp4.shake()
                txtSetPin.shake()
                txtReenterPin.shake()
                self.showToast(message: "Please Enter Validation Code")
                
            }else if txtOtp1.text == "" || txtOtp2.text == "" || txtOtp3.text == "" || txtOtp4.text == "" {
                txtOtp1.shake()
                txtOtp2.shake()
                txtOtp3.shake()
                txtOtp4.shake()
                self.showToast(message: "Please Enter 4 Digit Validation Code")
                
            }else{
                let strOTP = txtOtp1.text! + txtOtp2.text! + txtOtp3.text! + txtOtp4.text!
                if counter == 0{
                    self.showToast(message: "Your OTP is Expire Please Resend")
                    lblTimer.textColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)

                }else{
                    webserviceCallVerifyOTP(strOtp:strOTP)
                }
            }
            
        }
        
    }
}

//MARK:- Textfeild Delegate
extension GetOTPVC : UITextFieldDelegate{
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//            if txtSetPin.text?.count == 4{
//                btnOutletSubmit.layer.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
//                btnOutletSubmit.layer.masksToBounds = true
//
//            }
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtReenterPin || textField == txtSetPin{
        let maxLength = 4
           let currentString: NSString = (textField.text ?? "") as NSString
           let newString: NSString =
               currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 4{
                btnOutletSubmit.layer.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                btnOutletSubmit.layer.masksToBounds = true
            }else{
              //  textField.shake()

            }
           return newString.length <= maxLength
        }
            return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnBackOutlet.isSelected = false
        if textField == txtOtp1 || textField == txtOtp2 || textField == txtOtp3 || textField == txtOtp4{
            viewSetPin.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            viewReEnterPin.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            txtSetPin.text = ""
            txtReenterPin.text = ""
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
