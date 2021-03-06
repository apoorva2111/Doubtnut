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
    
    @IBOutlet weak var txtEmail: RCustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        // Do any additional setup after loading the view.
    }
}
extension LoginWithCodeVC:UITextFieldDelegate{
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtEmail.text!.isValidEmail() {
            viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
        }else{
            viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)

           
        if txtEmail.text!.isPhoneNumber {
                viewEmail.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            
            }else{
                viewEmail.borderColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
                btnOutletGetOTP.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)

            }
        }
            return true
    }
}

extension LoginWithCodeVC{
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnGetOtpAction(_ sender: Any) {
        let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
