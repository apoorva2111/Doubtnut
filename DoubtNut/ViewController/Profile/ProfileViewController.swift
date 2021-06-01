//
//  ProfileViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 09/03/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileView: UIView!
        @IBOutlet weak var customView: RCustomButton!
    @IBOutlet weak var editBioRefBtn: UIButton!
    @IBOutlet weak var menuRefBtn: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var gradeImageView: UIImageView!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var stateImageView: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var SATImageView: UIImageView!
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    
    @IBOutlet weak var schoolImageView: UIImageView!
    
    @IBOutlet weak var separatorLabel1: UILabel!
    

    @IBOutlet weak var watchHistoryRefBtn: UIButton!
    
    
    @IBOutlet weak var myDoubtrsRefBtn: UIButton!
    
    @IBOutlet weak var payementHistoryRefBtn: UIButton!
    
    @IBOutlet weak var watchHistoryLabel: UILabel!
    
    @IBOutlet weak var myDoubtsLabel: UILabel!
    
    
    @IBOutlet weak var paymentHistoryLabel: UILabel!
    
    @IBOutlet weak var separatorLabel2: UILabel!
    
    @IBOutlet weak var otheInformationLabel: UILabel!
    
    @IBOutlet weak var userDataRefBtn: UIButton!
    
    @IBOutlet weak var privacyPolicyBtnRef: UIButton!
    
    @IBOutlet weak var termasandConditionBtnRef: UIButton!
    
    @IBOutlet weak var contactUSRefBtn: UIButton!
    
    @IBOutlet weak var membershipLabel: UILabel!
    
    @IBOutlet weak var membershipBaseView: UIView!
    
    @IBOutlet weak var membershipInsideView: UIView!
    
    @IBOutlet weak var memeberShipPriceLabel: UILabel!
    
    
    @IBOutlet weak var membershipValiditylabel: UILabel!
    
    @IBOutlet weak var cancelMemberShipBtnRef: UIButton!
    @IBOutlet weak var viewFooter: Footerview!
    
    var strFirstName = ""
    var strLastName = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editBioRefBtn.layer.cornerRadius = 12
        editBioRefBtn.layer.borderWidth  = 2
        editBioRefBtn.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.2392156863, blue: 0.9137254902, alpha: 1)
        makeRounded()
        separatorLabel1.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        separatorLabel2.backgroundColor = UIColor.black.withAlphaComponent(0.5)
       
        viewFooter.footerDelegate = self
        viewFooter.imgProfile.image = #imageLiteral(resourceName: "Profile_selected")
        viewFooter.lblProfile.textColor = #colorLiteral(red: 1, green: 0.4183522463, blue: 0.2224330306, alpha: 1)
        viewFooter.imgHome.image = #imageLiteral(resourceName: "Home")
        viewFooter.lblHome.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        // Do any additional setup after loading the view.
        getProfileDetail()
    }
    func makeRounded() {
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func onClickEditButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "UpdateProfileViewController") as! UpdateProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onClickMenuButton(_ sender: UIButton) {
    }
    
    @IBAction func onClickWatchHistory(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "WatchHistoryViewController", storyBoard: "Profile")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickMyDoubts(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "QuestionAskedViewController", storyBoard: "Profile")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickPaymentHistory(_ sender: UIButton) {
    }
    
    @IBAction func onClickDataDisclosure(_ sender: UIButton) {
    }
    
    @IBAction func onClickPrivacyPolicy(_ sender: UIButton) {
       
        
        let vc = FlowController().instantiateViewController(identifier: "TermsAndConditionVC", storyBoard: "Setting")as! TermsAndConditionVC
        vc.strSelectedValue = "privacy Policy"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func onClickTermasandCondition(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "TermsAndConditionVC", storyBoard: "Setting")as! TermsAndConditionVC
        vc.strSelectedValue = "Terms And Condition"
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    @IBAction func onClickContactUs(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "TermsAndConditionVC", storyBoard: "Setting")as! TermsAndConditionVC
        vc.strSelectedValue = "Contact Us"

        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    
    @IBAction func onClickCancelMembership(_ sender: UIButton) {
    }
    
}

extension ProfileViewController:FooterviewDelegate{
    func didPressFooterButton(getType: String) {
        if getType == "Home"{
            let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
            self.navigationController?.pushViewController(vc, animated: false)
        }else if getType == "Doubt"{
            let vc = FlowController().instantiateViewController(identifier: "CustomCameraVC", storyBoard: "Home")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print(getType)
        }
    }
    
    
}
//MARK:- Call Api

extension ProfileViewController{
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
                                                
                                                
                                               // userNameLabel.text = (data["student_fname"] as! String) + " " + (data["student_lname"]as! String)
                                                if let firstName = data["student_fname"] as? String{
                                                    strFirstName = firstName
                                                }
                                                if let lastName = data["student_lname"] as? String{
                                                    strLastName = lastName
                                                }
                                                lblUserName.text = strLastName
                                                if let displayClass = data["display_class"] as? String{
                                                    gradeLabel.text = displayClass
                                                }
                                                
                                                if let imgUrl = data["img_url"] as? String {
                                                    profileImageView.contentMode = .scaleToFill
                                                profileImageView.sd_setImage(with: URL.init(string: imgUrl), completed: nil)
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
