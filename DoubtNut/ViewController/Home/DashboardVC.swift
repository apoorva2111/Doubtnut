//
//  DashboardVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 06/03/21.
//

import UIKit
import SideMenu
class DashboardVC: UIViewController {

    @IBOutlet weak var viewFooterview: Footerview!
    @IBOutlet weak var collectionMaths: UICollectionView!
    @IBOutlet weak var viewSetPin: UIView!
    @IBOutlet weak var viewFreeTrial: FreetrialView!
    @IBOutlet weak var txtSetPinOne: RCustomTextField!
    @IBOutlet weak var txtSetPinTwo: RCustomTextField!
    @IBOutlet weak var txtSetPinThree: RCustomTextField!
    @IBOutlet weak var txtSetPinFour: RCustomTextField!

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtSearchQues: UITextField!
    @IBOutlet weak var lblOtpLine1: UILabel!
    @IBOutlet weak var lblOtpLine2: UILabel!
    @IBOutlet weak var lblOtpLine3: UILabel!
    @IBOutlet weak var lblOtpLine4: UILabel!
    
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblSAT: UILabel!
    @IBOutlet weak var lblACT: UILabel!
   
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    
    var arrFeedData = [NSDictionary]()
    var arrGetData = [NSDictionary]()
    
    
    @IBAction func btnSetPinAction(_ sender: UIButton) {
        if sender.tag == 10 {
            viewSetPin.isHidden = true
        }else{
            //Set pin api
            validation()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFooterview.footerDelegate = self
        txtSearchQues.delegate = self
        // Do any additional setup after loading the view.
        registerXib()
        viewFreeTrial.isHidden = true
        
        if BoolValue.isFromSideMenuSetPin{
            BoolValue.isFromSideMenuSetPin = false
            viewSetPin.isHidden = false
//
            if userDef.value(forKey: "Login_pin") != nil{
                let pin = userDef.value(forKey: "Login_pin") as! String
                let characters = Array(pin)

                txtSetPinOne.text = String(characters[0])
                txtSetPinTwo.text = String(characters[1])
                txtSetPinThree.text = String(characters[2])
                txtSetPinFour.text = String(characters[3])
            }else{
                
            }
        }else{
        viewSetPin.isHidden = true
        }
        
        viewFreeTrial.freetrialViewDelegate = self
        viewFooterview.imgProfile.image = #imageLiteral(resourceName: "Profile")
        viewFooterview.lblProfile.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        viewFooterview.imgHome.image = #imageLiteral(resourceName: "Home_Selectd")
        viewFooterview.lblHome.textColor = #colorLiteral(red: 1, green: 0.4183522463, blue: 0.2224330306, alpha: 1)
        
   setView()

        callWebserviceForItems()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.callWebserviceGetdata()
        }
      //

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileDetail()
    }
    func setView() {
        txtSetPinOne.delegate = self
        txtSetPinTwo.delegate = self
        txtSetPinThree.delegate = self
        txtSetPinFour.delegate = self
       
        txtSetPinOne.valueType = .onlyNumbers
        txtSetPinTwo.valueType = .onlyNumbers
        txtSetPinThree.valueType = .onlyNumbers
        txtSetPinFour.valueType = .onlyNumbers
        
        
        txtSetPinOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtSetPinTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtSetPinThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtSetPinFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)

    }
    func registerXib() {
        self.collectionMaths.register(UINib(nibName: "MathCVCell", bundle: nil), forCellWithReuseIdentifier: "MathCVCell")
        
        self.tblList.register(HomeTVCell.nib(), forCellReuseIdentifier: "HomeTVCell")
        
        tblList.delegate = self
        tblList.dataSource = self
    }

    func validation(){
        self.view.endEditing(true)
        
            if txtSetPinOne.text == "" && txtSetPinTwo.text == "" && txtSetPinThree.text == "" && txtSetPinFour.text == ""{
                txtSetPinOne.shake()
                txtSetPinTwo.shake()
                txtSetPinThree.shake()
                txtSetPinFour.shake()
                self.showToast(message: "Please Enter Validation Code or Set Your 4 Digit PIN")
                
            }else if txtSetPinOne.text == "" || txtSetPinTwo.text == "" || txtSetPinThree.text == "" || txtSetPinFour.text == "" {
                txtSetPinOne.shake()
                txtSetPinTwo.shake()
                txtSetPinThree.shake()
                txtSetPinFour.shake()
                self.showToast(message: "Please Enter 4 Digit Validation Code or Set Your 4 Digit PIN")
                
            }else{
                let strOTP = txtSetPinOne.text! + txtSetPinTwo.text! + txtSetPinThree.text! + txtSetPinFour.text!
                print(strOTP)
callWebserviceForStorePin(pin: strOTP)
                
            }

        
    }
  
    @IBAction func onClickProfileButton(_ sender: UIButton) {
        let  menu = storyboard!.instantiateViewController(withIdentifier: "rightmenu") as? SideMenuNavigationController
               menu?.presentationStyle = .menuSlideIn
               menu?.menuWidth = 280
               menu?.leftSide =  false
              present(menu!,animated: true)
    }
    @IBAction func btnCameraAction(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "CustomCameraVC", storyBoard: "Home")
        self.navigationController?.pushViewController(vc, animated: true)

    }
}


extension DashboardVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionMaths.dequeueReusableCell(withReuseIdentifier: "MathCVCell", for: indexPath) as! MathCVCell
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionMaths.frame.width - 50, height: collectionMaths.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewFreeTrial.isHidden = false
    }
    
}
//MARK :- Tableview Delegate
extension DashboardVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblList.dequeueReusableCell(withIdentifier: "HomeTVCell", for: indexPath) as! HomeTVCell
        let objDict = arrFeedData[indexPath.row]
        cell.homeVC = self
        cell.setData(feedDict: objDict)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
}

//MARK :- Button Action
extension DashboardVC{
    @IBAction func btnSATAction(_ sender: UIButton) {
        if arrGetData.count>0{
            let obj = arrGetData[0]
            if "SAT prep"  == obj["title"] as! String || "SAT Prep"  == obj["title"] as! String{
                let vc = FlowController().instantiateViewController(identifier: "SATVC", storyBoard: "Home") as! SATVC
                vc.strHeader = "SAT"
                vc.id = String(obj["playlist_id"]as! String)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let obj = arrGetData[1]
                if "SAT prep"  == obj["title"] as! String || "SAT Prep"  == obj["title"] as! String{
                    let vc = FlowController().instantiateViewController(identifier: "SATVC", storyBoard: "Home") as! SATVC
                    vc.strHeader = "SAT"
                    vc.id = String(obj["playlist_id"]as! String)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        
    }
    
    @IBAction func btnACTAction(_ sender: Any) {
        if arrGetData.count>0{
            let obj = arrGetData[1]
            if "ACT Prep"  == obj["title"] as! String || "ACT prep"  == obj["title"] as! String{
                let vc = FlowController().instantiateViewController(identifier: "SATVC", storyBoard: "Home") as! SATVC
                vc.strHeader = "ACT"
                vc.id = String(obj["playlist_id"]as! String)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let obj = arrGetData[0]
                if "ACT Prep"  == obj["title"] as! String{
                
                    let vc = FlowController().instantiateViewController(identifier: "SATVC", storyBoard: "Home") as! SATVC
                    vc.strHeader = "ACT"
                    vc.id = String(obj["playlist_id"]as! String)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        
    }
    
    
    func callWebserviceGetdata()  {
       // BaseApi.showActivityIndicator(icon: nil, text: "")

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.com/v5/icons/getdata/27")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let auth = userDef.value(forKey: "Auth_token") as? String{
            request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("844", forHTTPHeaderField: "version_code")

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
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.com/v5/icons/getdata/27", message: "Response: \(jsonString)     version_code:- 844", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let dataJson = json["data"] as? NSArray{
                                                print(dataJson)
                                                for obj in dataJson{
                                                    arrGetData.append(obj as! NSDictionary)
                                                }
                                                
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
    
    
    func callWebserviceForItems()  {
        BaseApi.showActivityIndicator(icon: nil, text: "")

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v3/tesla/feed?page=1&source=home&with_video_type=1&offsetCursor=&supported_media_type=DASH%2CHLS%2CRTMP%2CBLOB%2CYOUTUBE")! as URL)

        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Njk5NTkzNTIsImlhdCI6MTYxNzcxNjY2MCwiZXhwIjoxNjgwNzg4NjYwfQ.t-XYGLwUvy2lTbmBfN0D3Ybm_rVkXGyghrHy8EgosK8", forHTTPHeaderField: "x-auth-token")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("844", forHTTPHeaderField: "version_code")

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
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.app/v3/tesla/feed?page=1&source=home", message: "Response: \(jsonString)     version_code:- 844", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation {
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let dataJson = json["data"] as? [String:Any]{
                                                BaseApi.hideActivirtIndicator()
                                                if let feedDate = dataJson["feeddata"] as? NSArray{
                                                    print(feedDate)
                                                    for objDict in feedDate {
                                                        self.arrFeedData.append(objDict as! NSDictionary)
                                                    }
                                                    self.tblHeightConstraint.constant = CGFloat(290*self.arrFeedData.count)

                                                    self.tblList.reloadData()
                                                    
                                                }

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
    
    func callWebserviceForAskQues() {
        
//
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let parameters = [
                          "question":"IOS",
                          "limit":"20",
                          "uploaded_image_question_id":"",
                          "question_text":txtSearchQues.text!] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.com/v10/questions/ask")! //change the url

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
        request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("776", forHTTPHeaderField: "version_code")

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
                    let jsonString = BaseApi.showParam(json: json)
                    let param = BaseApi.showParam(json: parameters)
                    UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param),  URL:- https://api.doubtnut.com/v10/questions/ask", message: "Response: \(jsonString)     version_code:- 776", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK"{
                            
                            if let meta = json["meta"] as? [String:AnyObject]{
                                let code = meta["code"] as! Int
                                if code == 200 {
                                    // create the alert
                                    OperationQueue.main.addOperation {
                                        BaseApi.hideActivirtIndicator()
                                        
                                        if let data = json["data"] as? [String:AnyObject]{
                                            self.txtSearchQues.resignFirstResponder()
                                            let vc = FlowController().instantiateViewController(identifier: "VIdeoListVC", storyBoard: "Home") as! VIdeoListVC
                                            vc.arrAskQuestion = data
                                            vc.questionstring = self.txtSearchQues.text!
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                                  //  }
                                }else{
                                    OperationQueue.main.addOperation {
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }
                        }else{
                            BaseApi.hideActivirtIndicator()

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
    func getProfileDetail(){
       // BaseApi.showActivityIndicator(icon: nil, text: "")
        let userId = userDef.value(forKey: "student_id") as! Int
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v1/tesla/profile/\(userId)")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzY5NDQ5OTgsImlhdCI6MTYyMDkwMzY4MSwiZXhwIjoxNjgzOTc1NjgxfQ.KTRsKuo07iRgVEjiCuO8HwV4ZdDZzkVjZix2sMqZt00", forHTTPHeaderField: "x-auth-token")
        request.addValue("845", forHTTPHeaderField: "version_code")
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
                            UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.app/v1/tesla/profile/\(userId)", message: "Response: \(jsonString)     version_code :- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                                if checkBtn == "OK"{
                                    
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? [String:Any]{
                                                
                                                if let imgUrl = data["img_url"] as? String {
                                                imgProfile.sd_setImage(with: URL.init(string: imgUrl), completed: nil)
                                                    userDef.setValue(imgUrl, forKey: "userProfile")
                                                    userDef.synchronize()
                                                }
                                                let userName = (data["student_fname"] as! String) + " " + (data["student_lname"]as! String)
                                               
                                                userDef.setValue(userName, forKey: "userName")
                                                userDef.synchronize()
                                             //   BaseApi.hideActivirtIndicator()

                                            }else{
                                             //   BaseApi.hideActivirtIndicator()
                                            }
                                            
                                            //
                                        }else{
                                         //   BaseApi.hideActivirtIndicator()
                                            
                                        }
                                        
                                    }
                                }else{
                                //    BaseApi.hideActivirtIndicator()
//
                                }
                            }
                        }
                        
                    }
                } catch let error {
                    self.showToast(message: "Something Went Wrong")
                    
                   // BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                }
            }
        })
        
        task.resume()
    }
}
extension DashboardVC : FooterviewDelegate{
    func didPressFooterButton(getType: String) {
        if getType == "Home"{
            print(getType)
        }else if getType == "Doubt"{
            let vc = FlowController().instantiateViewController(identifier: "CustomCameraVC", storyBoard: "Home")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print(getType)
            
            let vc = FlowController().instantiateViewController(identifier: "navProfile", storyBoard: "Profile") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
present(vc, animated: false, completion: nil)
        }
    }
    
}

extension DashboardVC : FreetrialViewDelegate{
    func didPressCrossButton(Tag: Int) {
        viewFreeTrial.isHidden = true

    }
    
    func didStartStudingAction() {
        viewFreeTrial.viewMembership.isHidden = false
        viewFreeTrial.viewStartStudying.isHidden = true
        viewFreeTrial.viewGiveAnotherChange.isHidden = true
    }
    
    func didKeepMyMembershipAction() {
        viewFreeTrial.viewMembership.isHidden = true
        viewFreeTrial.viewStartStudying.isHidden = true
        viewFreeTrial.viewGiveAnotherChange.isHidden = false
       // viewFreeTrial.lblGiveAnotherChance.text = "Give us another chance!"
       // viewFreeTrial.lblTellUsWhatWent.text = "Tell us what went wrong & get a free 7 day extension on us."
    }
    
    func didCancelMembershipAction() {
        viewFreeTrial.viewMembership.isHidden = true
        viewFreeTrial.viewStartStudying.isHidden = true
        viewFreeTrial.viewGiveAnotherChange.isHidden = false
    }
    
    func didDayExtendAction() {
        let vc = FlowController().instantiateViewController(identifier: "DayTrialViewController", storyBoard: "Main")
        self.present(vc, animated: true, completion: nil)
    }
    
    func didDontWontItAction() {
        
    }
    
    
}
//MARK:- Textfeild Delegate
extension DashboardVC : UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtSearchQues.text == "" {
            self.showToast(message: "Please Enter Text Doubt")
        }else{
            callWebserviceForAskQues()

        }
    }
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        if text!.count >= 1{
            
            switch textField{
            case txtSetPinOne:
                txtSetPinTwo.becomeFirstResponder()
                lblOtpLine1.backgroundColor=#colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            case txtSetPinTwo:
                txtSetPinThree.becomeFirstResponder()
                lblOtpLine2.backgroundColor=#colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)

            case txtSetPinThree:
                txtSetPinFour.becomeFirstResponder()
                lblOtpLine3.backgroundColor=#colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)

            case txtSetPinFour:
                txtSetPinFour.resignFirstResponder()
                lblOtpLine4.backgroundColor=#colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
               
            default:
                break
            }
        }else{
            switch textField{
            case txtSetPinFour:
                txtSetPinThree.becomeFirstResponder()
                lblOtpLine4.backgroundColor=#colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)

            case txtSetPinThree:
                txtSetPinTwo.becomeFirstResponder()
                lblOtpLine3.backgroundColor=#colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)

            case txtSetPinTwo:
                txtSetPinOne.becomeFirstResponder()
                lblOtpLine2.backgroundColor=#colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)

            case txtSetPinOne:
                txtSetPinOne.resignFirstResponder()
                lblOtpLine1.backgroundColor=#colorLiteral(red: 0.7642175555, green: 0.7642356753, blue: 0.7642259598, alpha: 1)

               
            default:
                break
            }
        }
        
    }
}
extension DashboardVC{
    func callWebserviceForStorePin(pin:String) {
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        let deviceID = UIDevice.current.identifierForVendor?.uuidString

       let parameters = ["pin":pin,"udid":deviceID]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.com/v1/student/store-pin")! //change the url

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
        let auth = userDef.value(forKey: "Auth_token") as! String
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
                    print(json)
                    let jsonString = BaseApi.showParam(json: json)
                    let param = BaseApi.showParam(json: parameters as [String : Any])
                    UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param),  URL:- https://api.doubtnut.com/v1/student/store-pin", message: "Response: \(jsonString)     version_code:- 862 ", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK"{
                            OperationQueue.main.addOperation {

                            if let meta = json["meta"] as? [String:AnyObject]{
                                let code = meta["code"] as! Int
                                if code == 200 {
                                    /**/
                                    BaseApi.hideActivirtIndicator()
                                    
                                    if let data = json["data"] as? [String:AnyObject]{
                                        if let message = data["message"]{
                                            self.viewSetPin.isHidden = true
                                            
                                            self.showToast(message: message as! String)
                                        }
                                        
                                    }
                                    // add an action (button)}else{
                                    BaseApi.hideActivirtIndicator()
//                                    self.showToast(message: "Something Went Wrong")
                                }
                                  //  }
                                }
                            }
                        }else{
                            BaseApi.hideActivirtIndicator()

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

/*
 "GET:  https://api.doubtnut.app/v3/tesla/feed?page=1&source=home&with_video_type=1&offsetCursor=&supported_media_type=DASH%2CHLS%2CRTMP%2CBLOB%2CYOUTUBE

 x-auth-token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Njk5NTkzNTIsImlhdCI6MTYyMDY0MjI5MCwiZXhwIjoxNjgzNzE0MjkwfQ.oSDqsry8VS6Q0dXcasv5sqqgZ02rTCwvtAaYcy5I7CI
 version_code: 844
 country: US"
 */
