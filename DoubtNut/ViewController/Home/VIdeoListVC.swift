//
//  VIdeoListVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 12/03/21.
//

import UIKit

class VIdeoListVC: UIViewController {

    @IBOutlet weak var viewFooter: Footerview!
   
    @IBOutlet weak var tblList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFooter.footerDelegate = self
        viewFooter.imgProfile.image = #imageLiteral(resourceName: "Profile_selected")
        viewFooter.lblProfile.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        viewFooter.imgHome.image = #imageLiteral(resourceName: "Home")
        viewFooter.lblProfile.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        // Do any additional setup after loading the view.
    }
    

}
extension VIdeoListVC : FooterviewDelegate{
    func didPressFooterButton(getType: String) {
        if getType == "Home"{
            print(getType)
            let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home")
            self.navigationController?.pushViewController(vc, animated: true)

        }else if getType == "Doubt"{
        }else{
            print(getType)
            
            let vc = FlowController().instantiateViewController(identifier: "navProfile", storyBoard: "Profile") as! UINavigationController
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
present(vc, animated: false, completion: nil)
        }
    }
    
    
}
extension VIdeoListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblList.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        return cell
    }
    
}
