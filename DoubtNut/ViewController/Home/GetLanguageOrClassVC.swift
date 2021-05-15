//
//  GetLanguageOrClassVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 31/03/21.
//

import UIKit

class GetLanguageOrClassVC: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblList: UITableView!
    
    var arrClassList = [NSDictionary]()
    var strSelectType = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.register(UINib.init(nibName: "GetLanguageAndClassListCell", bundle: nil), forCellReuseIdentifier: "GetLanguageAndClassListCell")
        tblList.delegate = self
        tblList.dataSource = self
      
        if strSelectType == "Class"{
            lblHeader.text = "Select Class"
            callWebserviceClassList()
            
        }else{
            lblHeader.text = "Select Language"

            callWebserviceForLanguage()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension GetLanguageOrClassVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrClassList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblList.dequeueReusableCell(withIdentifier: "GetLanguageAndClassListCell", for: indexPath) as! GetLanguageAndClassListCell
        let objClassList = arrClassList[indexPath.row]
        if strSelectType == "Class"{
            cell.lblList.text = objClassList["class_display"] as? String

        }else{
            cell.lblList.text = objClassList["language_display"] as? String

        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if strSelectType == "Class"{
            let objClassList = arrClassList[indexPath.row]
            SettingValue.chooseClass = objClassList["class_display"] as! String
            let classStr =  objClassList["class"] as! Int
            CallWebserviceForSetClass(strclass: String(classStr))
        }else{
            let objClassList = arrClassList[indexPath.row]
            let lang = objClassList["code"]
            SettingValue.chooseLanguage = objClassList["language_display"] as! String
            CallWebserviceForSetLanguage(strLang: lang as! String)
        }
    }
}

extension GetLanguageOrClassVC{
     
    func callWebserviceClassList() {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.com/v4/class/get-list/en")! as URL)
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
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.com/v4/class/get-list/en", message: "Response: \(jsonString)     version_code:- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? NSArray{
                                                for obj in data {
                                                    print(obj)
                                                    arrClassList.append(obj as! NSDictionary)
                                                }
                                                tblList.reloadData()
                                                BaseApi.hideActivirtIndicator()

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
                    OperationQueue.main.addOperation {
                    self.showToast(message: "Something Went Wrong")
                    
                    BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func  callWebserviceForLanguage()  {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.com/v2/language/get-list")! as URL)
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
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.com/v2/language/get-list", message: "Response: \(jsonString)     version_code:- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? NSArray{
                                                for obj in data {
                                                    print(obj)
                                                    arrClassList.append(obj as! NSDictionary)
                                                }
                                                tblList.reloadData()
                                                BaseApi.hideActivirtIndicator()

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
                    OperationQueue.main.addOperation {
                    self.showToast(message: "Something Went Wrong")
                    
                    BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func CallWebserviceForSetClass(strclass:String)  {
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let parameters :[String : Any] = ["student_class":strclass]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.com/v4/student/update-profile")! //change the url

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
        request.addValue("862", forHTTPHeaderField: "version_code")
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
                    let jsonString = BaseApi.showParam(json: json)
                    UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.com/v4/student/update-profile", message: "Response: \(jsonString)     version_code:- 862", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK"{
                            
                            OperationQueue.main.addOperation {
                                BaseApi.hideActivirtIndicator()
                            if let meta = json["meta"] as? [String:AnyObject]{
                                let code = meta["code"] as! Int
                                if code == 200 {
                                     
                                        self.navigationController?.popViewController(animated: true)
                                        
                                //  }

                                }else{

                                    BaseApi.hideActivirtIndicator()
                                }
                                }
                            }
                        }else{
                            BaseApi.hideActivirtIndicator()
                        }
                    }
                    /**/
                    // handle json...
                }
            } catch let error {
                OperationQueue.main.addOperation {
                self.showToast(message: "Something Went Wrong")

                BaseApi.hideActivirtIndicator()

                print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
    
    
    func CallWebserviceForSetLanguage(strLang:String)  {
        BaseApi.showActivityIndicator(icon: nil, text: "")
       
        let parameters :[String : Any] = ["language":strLang]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.com/v4/student/update-profile")! //change the url

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
        request.addValue("862", forHTTPHeaderField: "version_code")
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
                    let jsonString = BaseApi.showParam(json: json)
                    UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- \(url)", message: "Response: \(jsonString)     version_code:- 862", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK"{
                            
                            OperationQueue.main.addOperation {
                                BaseApi.hideActivirtIndicator()
                            if let meta = json["meta"] as? [String:AnyObject]{
                                let code = meta["code"] as! Int
                                if code == 200 {
                                        self.navigationController?.popViewController(animated: true)

                                }else{

                                    BaseApi.hideActivirtIndicator()
                                }
                                }
                            }
                        }else{
                            BaseApi.hideActivirtIndicator()
                        }
                        
                    }
                    
                    /**/
                    // handle json...
                }
            } catch let error {
                OperationQueue.main.addOperation {
                self.showToast(message: "Something Went Wrong")

                BaseApi.hideActivirtIndicator()

                print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
}
