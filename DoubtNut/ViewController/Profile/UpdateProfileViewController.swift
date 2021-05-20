//
//  UpdateProfileViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 11/03/21.
//

import UIKit
import CoreLocation
class UpdateProfileViewController: UIViewController {

    
    @IBOutlet weak var haederView: UIView!
    @IBOutlet weak var backBtnRef: UIButton!
    @IBOutlet weak var vcTitlelabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @IBOutlet weak var saveBtnRef: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var nameIcon: UIImageView!
    
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameSeparatorLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var genderIcon: UIImageView!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    
    @IBOutlet weak var maleCheckBoxButton: UIButton!
    
    
    @IBOutlet weak var maleLabel: UILabel!
    
    
    @IBOutlet weak var femaleCheckBoxButton: UIButton!
    
    
    @IBOutlet weak var femaleLabel: UILabel!
    
    @IBOutlet weak var gradeIcon: UIImageView!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var gradeView: UIView!
    
    @IBOutlet weak var examPrepIcon: UIImageView!
    
    @IBOutlet weak var satView: UIView!
    
    
    @IBOutlet weak var satIcon: UIImageView!
    
    @IBOutlet weak var prepLabel: UILabel!
    
    
    @IBOutlet weak var exampreperationLabel: UILabel!
    @IBOutlet weak var SATcheckBox: UIImageView!
    
    
    @IBOutlet weak var ActView: UIView!
    
    
    @IBOutlet weak var actLabel: UILabel!
    
    @IBOutlet weak var ActCheckBox: UIImageView!
    
    @IBOutlet weak var ActIcon: UIImageView!
    
    
    @IBOutlet weak var locationIcon: UIImageView!
    
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var ocationBorderLabel: UILabel!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    @IBOutlet weak var schoolNameIcon: UIImageView!
    
    
    @IBOutlet weak var schoolView: UIView!
    
    
    @IBOutlet weak var schoollabel: UILabel!
    
    
    @IBOutlet weak var schoolSeparatorLabel: UILabel!
    
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var btnsix: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnNine: UIButton!
    @IBOutlet weak var btnTen: UIButton!
    @IBOutlet weak var btnElevan: UIButton!
    @IBOutlet weak var btnTwelve: UIButton!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeRounded()
        
        satView.isUserInteractionEnabled  = true
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(Satview(sender:)))
        satView.addGestureRecognizer(gesture1)
        
        ActView.isUserInteractionEnabled  = true
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(ACTView(sender:)))
        ActView.addGestureRecognizer(gesture2)
         
        
        
        userProfileImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(sender:)))
        userProfileImage.addGestureRecognizer(gesture)
         
        let width: CGFloat = 107
        let height: CGFloat = 107
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: -shadowSize, y: height - (shadowSize * 0.4), width: width + shadowSize * 2, height: shadowSize)
        profileView.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        profileView.layer.shadowRadius = 5
        profileView.layer.shadowOpacity = 0.4
        getProfileDetail()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    
    
    }
    @IBAction func btnUploadImgAction(_ sender: UIButton) {
    }
    
    @IBAction func btnActAction(_ sender: UIButton) {
      
            ActCheckBox.image = #imageLiteral(resourceName: "Checked")
        SATcheckBox.image = #imageLiteral(resourceName: "Unchecked_")

    }
    @IBAction func btnSatAction(_ sender: UIButton) {
        SATcheckBox.image = #imageLiteral(resourceName: "Checked")
        ActCheckBox.image = #imageLiteral(resourceName: "Unchecked_")
    }
    @IBAction func onClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleZoomOut(sender: UITapGestureRecognizer) {
               print("Image action is settup")
        //here call image picker VC
    
    
           }
    @objc func Satview(sender: UITapGestureRecognizer) {
               print("SatView")
        //give action for satview to change icon
    
    
           }
    @objc func ACTView(sender: UITapGestureRecognizer) {
               print("ACTVIEW")
        //give action for ActView to change icon
    
    
           }

    func makeRounded() {
        userProfileImage.layer.masksToBounds = false
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height/2
        userProfileImage.clipsToBounds = true
        userProfileImage.layer.borderWidth = 5
        userProfileImage.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
    }
    
    @IBAction func onClickUpdateProfile(_ sender: UIButton) {
    }
    
    @IBAction func onClickMaleCheckBox(_ sender: UIButton) {
        maleCheckBoxButton.setImage(#imageLiteral(resourceName: "Checked_"), for: .normal)
        femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "Unchecked_"), for: .normal)
    }
    
    
    @IBAction func onClickFemaleCheckBoxButton(_ sender: UIButton) {
        maleCheckBoxButton.setImage(#imageLiteral(resourceName: "Unchecked_"), for: .normal)
        femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "Checked_"), for: .normal)
    }
    
    
    @IBAction func onClickgradeButton(_ sender: UIButton) {
        
        if sender.tag == 6{
            btnsix.layer.borderWidth = 1
            btnsix.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnsix.layer.masksToBounds = true
            
            btnSeven.layer.borderWidth = 0
            btnSeven.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnSeven.layer.masksToBounds = true
            
            btnEight.layer.borderWidth = 0
            btnEight.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnEight.layer.masksToBounds = true
            
            btnNine.layer.borderWidth = 0
            btnNine.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnNine.layer.masksToBounds = true
            
            btnTen.layer.borderWidth = 0
            btnTen.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTen.layer.masksToBounds = true
            
            btnElevan.layer.borderWidth = 0
            btnElevan.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnElevan.layer.masksToBounds = true
            
            btnTwelve.layer.borderWidth = 0
            btnTwelve.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTwelve.layer.masksToBounds = true
            
        }else if sender.tag == 7{
            btnSeven.layer.borderWidth = 1
            btnSeven.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnSeven.layer.masksToBounds = true
            
            btnsix.layer.borderWidth = 0
            btnsix.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnsix.layer.masksToBounds = true
            
            btnEight.layer.borderWidth = 0
            btnEight.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnEight.layer.masksToBounds = true
            
            btnNine.layer.borderWidth = 0
            btnNine.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnNine.layer.masksToBounds = true
            
            btnTen.layer.borderWidth = 0
            btnTen.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTen.layer.masksToBounds = true
            
            btnElevan.layer.borderWidth = 0
            btnElevan.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnElevan.layer.masksToBounds = true
            
            btnTwelve.layer.borderWidth = 0
            btnTwelve.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTwelve.layer.masksToBounds = true
            
        }else if sender.tag == 8{
            btnSeven.layer.borderWidth = 0
            btnSeven.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnSeven.layer.masksToBounds = true
            
            btnsix.layer.borderWidth = 0
            btnsix.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnsix.layer.masksToBounds = true
            
            btnEight.layer.borderWidth = 1
            btnEight.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnEight.layer.masksToBounds = true
            
            btnNine.layer.borderWidth = 0
            btnNine.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnNine.layer.masksToBounds = true
            
            btnTen.layer.borderWidth = 0
            btnTen.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTen.layer.masksToBounds = true
            
            btnElevan.layer.borderWidth = 0
            btnElevan.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnElevan.layer.masksToBounds = true
            
            btnTwelve.layer.borderWidth = 0
            btnTwelve.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTwelve.layer.masksToBounds = true
            
        }else if sender.tag == 9{
            btnSeven.layer.borderWidth = 0
            btnSeven.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnSeven.layer.masksToBounds = true
            
            btnsix.layer.borderWidth = 0
            btnsix.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnsix.layer.masksToBounds = true
            
            btnEight.layer.borderWidth = 0
            btnEight.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnEight.layer.masksToBounds = true
            
            btnNine.layer.borderWidth = 1
            btnNine.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnNine.layer.masksToBounds = true
            
            btnTen.layer.borderWidth = 0
            btnTen.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTen.layer.masksToBounds = true
            
            btnElevan.layer.borderWidth = 0
            btnElevan.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnElevan.layer.masksToBounds = true
            
            btnTwelve.layer.borderWidth = 0
            btnTwelve.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTwelve.layer.masksToBounds = true
            
        }else if sender.tag == 10{
            btnSeven.layer.borderWidth = 0
            btnSeven.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnSeven.layer.masksToBounds = true
            
            btnsix.layer.borderWidth = 0
            btnsix.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnsix.layer.masksToBounds = true
            
            btnEight.layer.borderWidth = 0
            btnEight.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnEight.layer.masksToBounds = true
            
            btnNine.layer.borderWidth = 0
            btnNine.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnNine.layer.masksToBounds = true
            
            btnTen.layer.borderWidth = 1
            btnTen.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnTen.layer.masksToBounds = true
            
            btnElevan.layer.borderWidth = 0
            btnElevan.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnElevan.layer.masksToBounds = true
            
            btnTwelve.layer.borderWidth = 0
            btnTwelve.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTwelve.layer.masksToBounds = true
            
        }else if sender.tag == 11{
            btnSeven.layer.borderWidth = 0
            btnSeven.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnSeven.layer.masksToBounds = true
            
            btnsix.layer.borderWidth = 0
            btnsix.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnsix.layer.masksToBounds = true
            
            btnEight.layer.borderWidth = 0
            btnEight.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnEight.layer.masksToBounds = true
            
            btnNine.layer.borderWidth = 0
            btnNine.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnNine.layer.masksToBounds = true
            
            btnTen.layer.borderWidth = 0
            btnTen.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTen.layer.masksToBounds = true
            
            btnElevan.layer.borderWidth = 1
            btnElevan.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnElevan.layer.masksToBounds = true
            
            btnTwelve.layer.borderWidth = 0
            btnTwelve.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTwelve.layer.masksToBounds = true
            
        }else{
            btnSeven.layer.borderWidth = 0
            btnSeven.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnSeven.layer.masksToBounds = true
            
            btnsix.layer.borderWidth = 0
            btnsix.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnsix.layer.masksToBounds = true
            
            btnEight.layer.borderWidth = 0
            btnEight.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnEight.layer.masksToBounds = true
            
            btnNine.layer.borderWidth = 0
            btnNine.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnNine.layer.masksToBounds = true
            
            btnTen.layer.borderWidth = 0
            btnTen.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnTen.layer.masksToBounds = true
            
            btnElevan.layer.borderWidth = 0
            btnElevan.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.4156862745, blue: 0.2235294118, alpha: 0)
            btnElevan.layer.masksToBounds = true
            
            btnTwelve.layer.borderWidth = 1
            btnTwelve.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
            btnTwelve.layer.masksToBounds = true
            
        }
        
    }

}

extension UpdateProfileViewController{
    
    func getProfileDetail(){
        BaseApi.showActivityIndicator(icon: nil, text: "")
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
                                                nameTextField.text = (data["student_fname"] as! String) + " " + (data["student_lname"]as! String)
                                                if let grade = data["display_class"] as? String{
                                                    if grade == "Grade 6"{
                                                        btnsix.layer.borderWidth = 1
                                                        btnsix.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                                                        btnsix.layer.masksToBounds = true
                                                    }else if grade == "Grade 7"{
                                                        btnSeven.layer.borderWidth = 1
                                                        btnSeven.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                                                        btnSeven.layer.masksToBounds = true
                                                    }else if grade == "Grade 8"{
                                                        btnEight.layer.borderWidth = 1
                                                        btnEight.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                                                        btnEight.layer.masksToBounds = true
                                                    }else if grade == "Grade 9"{
                                                        btnNine.layer.borderWidth = 1
                                                        btnNine.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                                                        btnNine.layer.masksToBounds = true
                                                    }else if grade == "Grade 10"{
                                                        btnTen.layer.borderWidth = 1
                                                        btnTen.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                                                        btnTen.layer.masksToBounds = true
                                                    }else if grade == "Grade 11"{
                                                        btnElevan.layer.borderWidth = 1
                                                        btnElevan.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                                                        btnElevan.layer.masksToBounds = true
                                                    }else{
                                                        btnTwelve.layer.borderWidth = 1
                                                        btnTwelve.layer.borderColor = #colorLiteral(red: 0.946038425, green: 0.4153085351, blue: 0.2230136693, alpha: 1)
                                                        btnTwelve.layer.masksToBounds = true
                                                    }
                                                }
                                                if let displayExam = data["display_exam"] as? String{
                                                    if displayExam == "SAT"{
                                                        SATcheckBox.image = #imageLiteral(resourceName: "Checked_")
                                                        ActCheckBox.image = #imageLiteral(resourceName: "Unchecked_")
                                                    }else{
                                                        ActCheckBox.image = #imageLiteral(resourceName: "Checked_")
                                                        SATcheckBox.image = #imageLiteral(resourceName: "Unchecked_")

                                                    }
                                                }
                                                if let schoolName = data["school_name"] as? String{
                                                    schoolTextField.text = schoolName
                                                }
                                                if let gender = data["gender"] as? Int{
                                                    print(gender)
                                                    if gender == 1{
                                                        maleCheckBoxButton.setImage(#imageLiteral(resourceName: "Checked_"), for: .normal)
                                                        femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "Unchecked_"), for: .normal)

                                                    }else{
                                                        femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "Checked_"), for: .normal)
                                                        maleCheckBoxButton.setImage(#imageLiteral(resourceName: "Unchecked_"), for: .normal)

                                                    }
                                                }
                                                BaseApi.hideActivirtIndicator()

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
}

extension UpdateProfileViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //locations = 21.71261665933815 81.53306267398155
        getAddressFromLatLon(pdblLatitude: String(locValue.latitude), withLongitude: String(locValue.longitude))

    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
//                        print(pm.country)
//                        print(pm.locality)
//                        print(pm.subLocality)
//                        print(pm.thoroughfare)
//                        print(pm.postalCode)
//                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
//                        if pm.postalCode != nil {
//                            addressString = addressString + pm.postalCode! + " "
//                        }


                        print(addressString)
                        self.locationTextField.text = addressString
                  }
            })

        }
}
extension UpdateProfileViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    func presentPhotoActionSheet() {
        
        let alert = UIAlertController(title: "Add Profile Image", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        let cameraAlert = UIAlertAction(title: "Camera",
                                        style: .default,
                                        handler:{ [weak self] _ in
                                            self?.presentCamera()
                                           
                                            
                                            
                                        })
        let galleryAlert = UIAlertAction(title: "Gallery",
                                         style: .default,
                                         handler:{ [weak self] _ in
                                            
                                            self?.presentPhotoPicker()
                                         })
        let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        alert.addAction(cameraAlert)
        alert.addAction(galleryAlert)
        self.present(alert, animated: true)
        alert.view.superview?.isUserInteractionEnabled = true
        alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        
    }
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            userProfileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)

    }
}
