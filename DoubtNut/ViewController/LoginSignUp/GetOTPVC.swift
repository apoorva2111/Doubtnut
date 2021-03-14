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
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        validation()
    }
    var session_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        // Do any additional setup after loading the view.
        print(session_id)
    }
    

}
//MARK:- Webservice Call
extension GetOTPVC{
    func webserviceCallVerifyOTP(strOtp: String){
        let params:[String: Any] = ["otp":strOtp,"session_id":session_id]

        var request = URLRequest(url: URL(string: "https://api.doubtnut.app/v4/student/verify")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
      //  request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      //  request.addValue("847", forHTTPHeaderField: "version_code")
      //  request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NjAyODk5ODIsImlhdCI6MTYxNTU3Mjk4NCwiZXhwIjoxNjc4NjQ0OTg0fQ._eOZrum06hEfpeGv9TXZe78xShOB3Dj9fU_V3ghdjpM", forHTTPHeaderField: "x-auth-token")
        request.addValue("US", forHTTPHeaderField: "country")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
                    // self.navigationController?.pushViewController(vc, animated: true)

            } catch {
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
        if txtOtp1.text == "" && txtOtp2.text == "" && txtOtp3.text == "" && txtOtp4.text == "" && txtSetPin.text == "" && txtReenterPin.text == ""{
            txtOtp1.shake()
            txtOtp2.shake()
            txtOtp3.shake()
            txtOtp4.shake()
            txtSetPin.shake()
            txtReenterPin.shake()
            self.showToast(message: "Please Enter Validation Code or Set Your 4 Digit PIN")
        
        }else if txtOtp1.text == "" || txtOtp2.text == "" || txtOtp3.text == "" || txtOtp4.text == "" {
            txtOtp1.shake()
            txtOtp2.shake()
            txtOtp3.shake()
            txtOtp4.shake()
            self.showToast(message: "Please Enter 4 Digit Validation Code or Set Your 4 Digit PIN")

        }else if txtSetPin.text != "" && txtReenterPin.text != ""{
            if txtSetPin.text!.count > 4 || txtReenterPin.text!.count > 4 {
               // txtSetPin.shake()
                self.showToast(message: "Please Enter 4 Digit PIN")

            }else if txtSetPin.text != txtReenterPin.text{
                txtSetPin.shake()
                txtReenterPin.shake()
                self.showToast(message: "Set PIN and Reset PIN is Not Match")

            }else{
                //Apicall
            }
        }else{
            let strOTP = txtOtp1.text! + txtOtp2.text! + txtOtp3.text! + txtOtp4.text!
            webserviceCallVerifyOTP(strOtp:strOTP)
        }
        
    }
}

//MARK:- Textfeild Delegate
extension GetOTPVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtReenterPin || textField == txtSetPin{
        let maxLength = 4
           let currentString: NSString = (textField.text ?? "") as NSString
           let newString: NSString =
               currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length > 4{
                textField.shake()
            }
           return newString.length <= maxLength
        }
            return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
