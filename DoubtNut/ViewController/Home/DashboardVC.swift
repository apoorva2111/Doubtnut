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
    @IBOutlet weak var viewFreeTrial: FreetrialView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        viewFooterview.footerDelegate = self
        // Do any additional setup after loading the view.
        registerXib()
        viewFreeTrial.isHidden = true
        viewFreeTrial.freetrialViewDelegate = self
        
        viewFooterview.imgProfile.image = #imageLiteral(resourceName: "Profile")
        viewFooterview.lblProfile.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        viewFooterview.imgHome.image = #imageLiteral(resourceName: "Home_Selectd")
        viewFooterview.lblProfile.textColor = #colorLiteral(red: 1, green: 0.4183522463, blue: 0.2224330306, alpha: 1)
    }
    func registerXib() {
        self.collectionMaths.register(UINib(nibName: "MathCVCell", bundle: nil), forCellWithReuseIdentifier: "MathCVCell")

    }

  
    @IBAction func onClickProfileButton(_ sender: UIButton) {
        let  menu = storyboard!.instantiateViewController(withIdentifier: "rightmenu") as! SideMenuNavigationController
        
        present(menu,animated: true, completion: nil)

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
extension DashboardVC{
    @IBAction func btnSATAction(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "SATVC", storyBoard: "Home")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnACTAction(_ sender: Any) {
        let vc = FlowController().instantiateViewController(identifier: "SATVC", storyBoard: "Home")
        self.navigationController?.pushViewController(vc, animated: true)
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
