//
//  VIdeoListVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 12/03/21.
//

import UIKit
import SDWebImage

class VIdeoListVC: UIViewController {

    @IBOutlet weak var viewFooter: Footerview!
   
    @IBOutlet weak var imgGif: UIImageView!
    @IBOutlet weak var tblList: UITableView!
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var arrAskQuestion = [String:AnyObject]()
    var arrList = [NSDictionary]()
    
    var imgUpload : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewFooter.footerDelegate = self
        viewFooter.imgProfile.image = #imageLiteral(resourceName: "Profile_selected")
        viewFooter.lblProfile.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        viewFooter.imgHome.image = #imageLiteral(resourceName: "Home")
        viewFooter.lblProfile.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        // Do any additional setup after loading the view.
        showVideoList()
        
    }
    func showVideoList(){
        imgGif.image = imgUpload
        let quesArr = arrAskQuestion["matched_questions"] as! NSArray
        for objQues in quesArr {
            let obj = objQues as! NSDictionary
            arrList.append(obj)
            
        }
        tblList.reloadData()
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
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblList.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let objList = arrList[indexPath.row]
        cell.lblVideoID.text = objList["_id"] as? String
        if let objSource = objList["_source"] as? NSDictionary{
            let view = objSource["views"] as! Int
            cell.lblVideoView.text =  String(view)
           let like = objSource["likes"] as! Int
            cell.lblVideoLike.text = String(like)
        }
        let imgUrl = objList["question_thumbnail"] as? String
        cell.imgThumbnil.sd_imageIndicator = SDWebImageActivityIndicator.gray

            cell.imgThumbnil.sd_setImage(with: URL(string: imgUrl!), completed: nil)
        
        return cell
    }
    
}
