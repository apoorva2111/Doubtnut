//
//  SettingsViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 12/03/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var headerView: RCustomButton!
    @IBOutlet weak var backRefBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginIcon: UIImageView!
    @IBOutlet weak var loginRefBtn: UIButton!
    @IBOutlet weak var termsIcon: UIImageView!
    @IBOutlet weak var termAndConditionRefBtn: UIButton!
    @IBOutlet weak var privacyIcon: UIImageView!
    @IBOutlet weak var privacyBtnRef: UIButton!
    @IBOutlet weak var contactIcon: UIImageView!
    @IBOutlet weak var contactRefBtn: UIButton!
    @IBOutlet weak var aboutIcon: UIImageView!
    @IBOutlet weak var aboutRefBtn: UIButton!
    @IBOutlet weak var rateUsIcon: UIImageView!
    @IBOutlet weak var rateUsRefBtn: UIButton!
    @IBOutlet weak var inviteFriendsIcon: UIImageView!
    @IBOutlet weak var inviteFriendsRefBtn: UIButton!
    @IBOutlet weak var howtouseIcon: UIImageView!
    @IBOutlet weak var howToUseRefBtn: UIButton!
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var notificationSettingsRefBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func onClickDismissVC(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "DashboardVC") as! DashboardVC
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
    }
    
    @IBAction func onClickTermAndCondition(_ sender: UIButton) {
    }
    
    @IBAction func onClickPrivacyPolicy(_ sender: UIButton) {
    }
    
    @IBAction func onClickContactUs(_ sender: UIButton) {
    }
    
    @IBAction func onClickAboutUs(_ sender: UIButton) {
    }
    
    
    @IBAction func onClickRateUs(_ sender: UIButton) {
    }
    
    
    @IBAction func onClickInviteFriends(_ sender: UIButton) {
    }
    
    
    @IBAction func onClickHowToUse(_ sender: UIButton) {
    }
    
    @IBAction func onClickNotificationSettings(_ sender: UIButton) {
    }
    
    
    
    
    
    
}