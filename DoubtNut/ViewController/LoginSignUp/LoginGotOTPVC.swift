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

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        self.view.endEditing(true)

        validation()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOtp1.becomeFirstResponder()
setView()
        // Do any additional setup after loading the view.
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
                webserviceCallVerifyOTP(strOtp:strOTP)
            }
            
        }
        
    }

//MARK:- Textfeild Delegate
extension LoginGotOTPVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        
                        
                       
                    }
print(json)
                    if let meta = json["meta"] as? [String:AnyObject]{
                        let code = meta["code"] as! Int
                        if code == 200 {
                           /*["meta": {
                             code = 200;
                             message = "User registered";
                             success = 1;
                         }, "data": {
                             intro =     (
                                         {
                                     "question_id" = 2116599;
                                     type = intro;
                                     video = "https://doubtnut-static.s.llnwi.net/static/intro-video/NewAppTutorial02-720p-02.mp4";
                                 },
                                         {
                                     "question_id" = 2200030;
                                     type = community;
                                     video = "https://doubtnut-static.s.llnwi.net/static/intro-video/NewAppTutorial03-720p-02.mp4";
                                 }
                             );
                             "is_new_user" = 0;
                             "onboarding_video" = "https://doubtnut-static.s.llnwi.net/static/intro-video/NewAppTutorial02-720p-02.mp4";
                             "student_id" = 38666646;
                             "student_username" = amy1973akk;
                             token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mzg2NjY2NDYsImlhdCI6MTYxNTg3OTk5MywiZXhwIjoxNjc4OTUxOTkzfQ.uZ3hClH4V1Dj0ZBxylr-MXdL6u55dr4BgZG2IjvI4V4";
                         }]*/
                            // create the alert
                                BaseApi.hideActivirtIndicator()
                                
                                
                                // add an action (button)
                                    let vc = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home") as! UINavigationController
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: false, completion: nil)
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
}
