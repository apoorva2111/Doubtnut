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
    @IBOutlet weak var gradeCollection: UICollectionView!
    
    
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
    @IBOutlet weak var btnSATOutlet: UIButton!
    @IBOutlet weak var btnACTOutlet: UIButton!
    

    let locationManager = CLLocationManager()
    var arrClass = [NSDictionary]()
    var strGrade = ""
    var gradeInt = 0
    var strDisplayExam = ""
    var imgBase64  = ""
    var arrGetData = [NSDictionary]()

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
    getGradeList()

        
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
        presentPhotoActionSheet()
    }
    
    @IBAction func btnActAction(_ sender: UIButton) {

        if sender.isSelected{
            sender.isSelected = false
            ActCheckBox.image = #imageLiteral(resourceName: "Unchecked_")
        }else{
            sender.isSelected = true
            ActCheckBox.image = #imageLiteral(resourceName: "Checked_")
        }

    }
    /*
     (
             {
             "feature_type" = sat;
             id = 825;
             "is_show" = 1;
             link = "https://d10lpgp6xz60nq.cloudfront.net/engagement_framework/D2C7D785-60D4-B08B-9D00-3509A68EE522.webp";
             "playlist_id" = 133468;
             "playlist_title" = "SAT prep";
             position = 1;
             time = "2021-01-11T16:37:54.000Z";
             title = "SAT Prep";
         },
             {
             "feature_type" = act;
             id = 818;
             "is_show" = 1;
             link = "https://d10lpgp6xz60nq.cloudfront.net/engagement_framework/67A8C41E-FDCA-B552-E88A-3EA8F251210E.webp";
             "playlist_id" = 133467;
             "playlist_title" = ACT;
             position = 2;
             time = "2021-01-11T16:37:54.000Z";
             title = "ACT Prep";
         }
     )
     */
    @IBAction func btnSatAction(_ sender: UIButton) {
     
        if sender.isSelected{
            sender.isSelected = false
            SATcheckBox.image = #imageLiteral(resourceName: "Unchecked_")
        }else{
            sender.isSelected = true
            SATcheckBox.image = #imageLiteral(resourceName: "Checked_")
        }
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
        uploadProfile(coaching: "", date_of_birth: "", gender: 0, exam: [], imgBase64: imgBase64, name: nameTextField.text!, classGrade: String(gradeInt), geoDict: [:], school: "")
    }
    
    @IBAction func onClickMaleCheckBox(_ sender: UIButton) {
        maleCheckBoxButton.setImage(#imageLiteral(resourceName: "Checked_"), for: .normal)
        femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "Unchecked_"), for: .normal)
    }
    
    
    @IBAction func onClickFemaleCheckBoxButton(_ sender: UIButton) {
        maleCheckBoxButton.setImage(#imageLiteral(resourceName: "Unchecked_"), for: .normal)
        femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "Checked_"), for: .normal)
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
                            BaseApi.hideActivirtIndicator()
                            UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.app/v1/tesla/profile/\(userId)", message: "Response: \(jsonString)     version_code :- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                                if checkBtn == "OK"{
                                    
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? [String:Any]{
                                                nameTextField.text = (data["student_fname"] as! String) + " " + (data["student_lname"]as! String)
                                                if let grade = data["display_class"] as? String{
                                                    strGrade = grade
                                                }
                                                if let displayExam = data["display_exam"] as? String{
                                                    if displayExam == "SAT"{
                                                        strDisplayExam = displayExam
                                                        btnSATOutlet.isSelected = true
                                                        SATcheckBox.image = #imageLiteral(resourceName: "Checked_")
                                                        ActCheckBox.image = #imageLiteral(resourceName: "Unchecked_")
                                                    }else if displayExam == "ACT"{
                                                        strDisplayExam = displayExam
                                                        btnACTOutlet.isSelected = true
                                                        ActCheckBox.image = #imageLiteral(resourceName: "Checked_")
                                                        SATcheckBox.image = #imageLiteral(resourceName: "Unchecked_")

                                                    }else{
                                                        strDisplayExam = displayExam
                                                        btnSATOutlet.isSelected = true
                                                        SATcheckBox.image = #imageLiteral(resourceName: "Checked_")
                                                        ActCheckBox.image = #imageLiteral(resourceName: "Unchecked_")
                                                        
                                                        strDisplayExam = displayExam
                                                        btnACTOutlet.isSelected = true
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
                                                if let imgUrl = data["img_url"] as? String {
                                                    userProfileImage.contentMode = .scaleToFill
                                                userProfileImage.sd_setImage(with: URL.init(string: imgUrl), completed: nil)
                                                }
                                                gradeCollection.reloadData()
                                                BaseApi.hideActivirtIndicator()
                                                webservideForSAt()

                                            }else{
                                                BaseApi.hideActivirtIndicator()
                                                webservideForSAt()

                                            }
                                            
                                            //
                                        }else{
                                            BaseApi.hideActivirtIndicator()
                                            webservideForSAt()

                                            
                                        }
                                        
                                    }
                                }else{
                                    BaseApi.hideActivirtIndicator()
                                    webservideForSAt()


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
    func webservideForSAt() {
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
                                      BaseApi.hideActivirtIndicator()
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
    
    func getGradeList()  {
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v4/class/get-list/en")! as URL)
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
                            UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.app/v4/class/get-list/en", message: "Response: \(jsonString)     version_code :- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                                if checkBtn == "OK"{
                                    
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            BaseApi.hideActivirtIndicator()

                                            if let classData = json["data"] as? NSArray{
                                                if arrClass.count>0{
                                                    arrClass.removeAll()
                                                }
                                                var arrClassDict = [NSDictionary]()
                                                for objCLass in classData {
                                                    arrClassDict.append(objCLass as! NSDictionary)
                                                }
                                                if arrClassDict.count>0{
                                                //arrClass.sorted{$1["class"] as! Int > $0["class"] as! Int}
                                                    arrClass = arrClassDict.sorted { $0["class"] as? Int ?? .zero < $1["class"] as? Int ?? .zero }

                                                }
                                                gradeCollection.reloadData()
                                                self.getProfileDetail()

                                            }

                                            }else{
                                                self.getProfileDetail()
                                                BaseApi.hideActivirtIndicator()
                                            }
                                            
                                            //
                                        }else{
                                            self.getProfileDetail()

                                            BaseApi.hideActivirtIndicator()
                                            
                                        }
                                        
                                    
                            }else{
                                self.getProfileDetail()

                                    BaseApi.hideActivirtIndicator()

                                }
                            }
                        }
                        
                    }
                } catch let error {
                    OperationQueue.main.addOperation {
                    self.showToast(message: "Something Went Wrong")
                    self.getProfileDetail()

                    BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func uploadProfile(coaching:String, date_of_birth: String, gender : Int, exam:[Int], imgBase64:String,name:String,classGrade: String,geoDict:NSDictionary,school:String)  {
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let parameters = [
            "coaching":coaching,
            "date_of_birth":date_of_birth,
            "gender":gender,
            "exam":exam,
            "img_url":imgBase64,
            "name":name,
            "class":classGrade,
            "geo":geoDict,
            "school":school] as [String : Any]
     print(parameters)
        let userId = userDef.value(forKey: "student_id") as! Int

        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v2/student/\(userId))/profile")! //change the url
        
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
        request.addValue("845", forHTTPHeaderField: "version_code")
        
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
    
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
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
                    if placemarks == nil{
                        return
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
        //convert the image to NSData first
        let imageData:NSData = userProfileImage.image!.jpegData(compressionQuality: 0.9)! as NSData
//userProfileImage.image!.pngData(0.5)! as NSData
        // convert the NSData to base64 encoding
        imgBase64 =  imageData.base64EncodedString(options: .lineLength64Characters) //imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        dismiss(animated: true, completion: nil)

    }
}

extension UpdateProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrClass.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gradeCollection.dequeueReusableCell(withReuseIdentifier: "GradeCVCell", for: indexPath) as! GradeCVCell
        let objClass = arrClass[indexPath.row]
        let gradeText = objClass["class_display"] as? String
        let components = gradeText?.components(separatedBy: " ")
        if let classStr = components?[1]{
            cell.lblGrade.text = classStr + "th"
        }
        if strGrade == objClass["class_display"] as? String{
            cell.viewMain.layer.borderWidth = 2
        }else{
            cell.viewMain.layer.borderWidth = 0
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objClass = arrClass[indexPath.row]
        strGrade = objClass["class_display"] as! String
        gradeInt = objClass["class"] as! Int
        gradeCollection.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65 , height: 40)
    }
   
}
