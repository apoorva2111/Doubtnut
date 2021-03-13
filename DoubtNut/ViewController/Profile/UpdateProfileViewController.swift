//
//  UpdateProfileViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 11/03/21.
//

import UIKit

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
    }
    
    
    @IBAction func onClickFemaleCheckBoxButton(_ sender: UIButton) {
    }
    
    
    @IBAction func onClickgradeButton(_ sender: UIButton) {
        
        //for these i connect all grade buttons to this single outlet
        //plese gave tag to each button and ccess according to tag value
        
    }
    
    
    
    
    
    
    
    
    
    

}
