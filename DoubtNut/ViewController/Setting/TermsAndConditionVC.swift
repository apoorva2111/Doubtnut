//
//  TermsAndConditionVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 30/03/21.
//

import UIKit

class TermsAndConditionVC: UIViewController {
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var lblTermsAndConditon: UILabel!
  
    @IBOutlet weak var lblDiscription: UILabel!
  
    var strSelectedValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if strSelectedValue == "Terms And Condition"{
            lblTermsAndConditon.text = "Terms and Condition"
            callTermsNCondition()

        }else if strSelectedValue == "privacy Policy"{
            lblTermsAndConditon.text = "Privacy Policy"
            callWebservicePrivacyPolicy()
        }else if strSelectedValue == "About Us"{
            lblTermsAndConditon.text = "About Us"
            callWebserviceAbout()
        }else if strSelectedValue == "Contact Us"{
            lblTermsAndConditon.text = "Contact Us"
            callWebserviceContactUs()
        }
        
    }
    
    func callTermsNCondition()  {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.com/v2/settings/get-tnc")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("850", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                print("Response: \(String(describing: response))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        OperationQueue.main.addOperation { [self] in
                            let jsonString = BaseApi.showParam(json: json)
                            UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.com/v2/settings/get-tnc", message: "Response: \(jsonString)     version_code :- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                                if checkBtn == "OK"{
                                    
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? [String:Any]{
                                                let dataObj = data["tnc"] as! String
                                                print(dataObj.html2String)
                                                BaseApi.hideActivirtIndicator()
                                                lblDiscription.text =  dataObj.html2String

                                            }else{
                                                BaseApi.hideActivirtIndicator()
                                            }
                                            
                                            //
                                        }else{
                                            BaseApi.hideActivirtIndicator()
                                            
                                        }
                                        
                                    }
                                }else{
                                    BaseApi.hideActivirtIndicator()

                                }
                            }
                        }
                        
                    }
                } catch let error {
                    self.showToast(message: "Something Went Wrong")
                    
                    BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                }
            }
        })
        
        task.resume()
    }

    func callWebservicePrivacyPolicy()  {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.com/v2/settings/get-privacy")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("850", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                print("Response: \(String(describing: response))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        let jsonString = BaseApi.showParam(json: json)
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api URL:- https://api.doubtnut.com/v2/settings/get-privacy", message: "Response: \(jsonString)     version_code :- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? [String:Any]{
                                                let dataObj = data["privacy"] as! String
                                                print(dataObj.html2String)
                                                lblDiscription.text =  dataObj.html2String
                                                BaseApi.hideActivirtIndicator()
                                              
                                            }else{
                                                BaseApi.hideActivirtIndicator()
                                            }
                                            
                                        
                                        }else{
                                            BaseApi.hideActivirtIndicator()
                                            
                                        }
                                        
                                    }
                                }
                            }else{
                                BaseApi.hideActivirtIndicator()

                            }
                        }
                        
                    }
                } catch let error {
                    self.showToast(message: "Something Went Wrong")
                    
                    BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                }
            }
        })
        
        task.resume()
    }
    func callWebserviceAbout()  {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.com/v2/settings/get-about-us")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("850", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                print("Response: \(String(describing: response))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        let jsonString = BaseApi.showParam(json: json)
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api URL:- https://api.doubtnut.com/v2/settings/get-about-us", message: "Response: \(jsonString)     version_code :- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? [String:Any]{
                                                let dataObj = data["aboutus"] as! String
                                                print(dataObj.html2String)
                                                BaseApi.hideActivirtIndicator()
                                                lblDiscription.text =  dataObj.html2String

                                            }else{
                                                BaseApi.hideActivirtIndicator()
                                            }
                                            
                                            //
                                        }else{
                                            BaseApi.hideActivirtIndicator()
                                            
                                        }
                                        
                                    }
                                }
                            }else{
                                BaseApi.hideActivirtIndicator()

                            }
                        }
                        
                    }
                } catch let error {
                    self.showToast(message: "Something Went Wrong")
                    
                    BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                }
            }
        })
        
        task.resume()
    }
    
    func callWebserviceContactUs()  {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.com/v2/settings/get-contact-us")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("850", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                print("Response: \(String(describing: response))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        let jsonString = BaseApi.showParam(json: json)
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api URL:-https://api.doubtnut.com/v2/settings/get-contact-us", message: "Response: \(jsonString)     version_code :- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? [String:Any]{
                                                let dataObj = data["contactus"] as! String
                                                print(dataObj.html2String)
                                                BaseApi.hideActivirtIndicator()
                                                lblDiscription.text =  dataObj.html2String
                                                
                                            }else{
                                                BaseApi.hideActivirtIndicator()
                                            }
                                            
                                            //
                                        }else{
                                            BaseApi.hideActivirtIndicator()
                                            
                                        }
                                        
                                    }
                                }
                            }else{
                                BaseApi.hideActivirtIndicator()

                            }
                        }
                        
                    }
                } catch let error {
                    self.showToast(message: "Something Went Wrong")
                    
                    BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                }
            }
        })
        
        task.resume()
    }

}
