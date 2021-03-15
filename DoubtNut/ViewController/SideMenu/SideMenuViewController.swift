//
//  SideMenuViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 08/03/21.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNamelbl: UILabel!
    @IBOutlet weak var viewProfileRefBtn: UIButton!
    @IBOutlet weak var seperatorLabel: UILabel!
    
    
    
    
    var imageArray = [[UIImage(named: "Vector"),UIImage(named: "grade")],
                      [UIImage(named: "history"),UIImage(named: "QA"),UIImage(named: "playlist")],
                      [UIImage(named: "payment"),UIImage(named: "settings")]]
    var titleArray = [["Login PIN ____(Change Pin)","Change Grade(Grade 12)"],
                      ["History","Question Asked History","Watch Later"],
                      ["Payment History","Settings"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRounded()
        
        //Tableview
        menuTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
    }
    func makeRounded() {
        
        userProfileImage.layer.borderWidth = 4
        userProfileImage.layer.masksToBounds = false
        userProfileImage.layer.borderColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        userProfileImage.clipsToBounds = true
    }
    
    @IBAction func onClickViewProfile(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        
    
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.sideMenuImage.isHidden = true
                cell.sideMenuTitle.isHidden = true
                cell.changeGradeView.isHidden = true
                cell.loginImageView.image = UIImage(named: "Vector")
                cell.loginLabel.text = "Login Pin"
                cell.firstPinTextField.text = "1"
                cell.secondPinTextField.text = "2"
                cell.ThirdPinTextField.text = "3"
                cell.fourthPinTextField.text = "4"
            }
            else if indexPath.row == 1 {
                cell.sideMenuImage.isHidden = true
                cell.sideMenuTitle.isHidden = true
                cell.loginView.isHidden = true
                cell.gradeImageView.image = UIImage(named: "grade")
                cell.gradeTitleLabel.text = "Change Grade"
            }
        }
            else {
                cell.loginView.isHidden = true
                cell.changeGradeView.isHidden = true
                
                cell.sideMenuImage.image = imageArray[indexPath.section][indexPath.row]
                cell.sideMenuTitle.text = titleArray[indexPath.section][indexPath.row]
            }
            
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  1.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return imageArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.section == 1 {
            if indexPath.row == 0 {
                print(" is tapped 0 ")
//                let vc = storyboard?.instantiateViewController(identifier: "SATVC") as! SATVC
//                vc.modalPresentationStyle = .fullScreen
//                present(vc, animated: true)
                let story = UIStoryboard(name: "Profile", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "WatchHistoryViewController") as! WatchHistoryViewController
                self.navigationController?.pushViewController(vc, animated: true)

            }
            else if indexPath.row == 1 {
                print(" is tapped 1")
                print(" QA is tapped")
                let story = UIStoryboard(name: "Profile", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "QuestionAskedViewController") as! QuestionAskedViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 2 {
                print(" is tapped 2")
                let story = UIStoryboard(name: "Profile", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "WatchHistoryViewController") as! WatchHistoryViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.section == 2{
            if indexPath.row == 1{
                let vc = storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
      
        
        
        
        
//        if indexPath.row == 0 {
//            print(" is tapped 0 ")
//            let vc = storyboard?.instantiateViewController(identifier: "SATVC") as! SATVC
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
//        }
//        else if indexPath.row == 1 {
//            print(" is tapped 1")
//            //instantiateViewController
//        }
//        else if indexPath.row == 2 {
//            print(" is tapped 2")
//            //instantiateViewController
//        }
//        else if indexPath.row == 3 {
//            print(" is tapped 3")
//            //instantiateViewController
//        }
//        else if indexPath.row == 4 {
//            print(" is tapped 4")
//            //instantiateViewController
//        }
//        else if indexPath.row == 5 {
//            print(" is tapped 5")
//            //instantiateViewController
//        }
//        else if indexPath.row == 6 {
//            print(" is tapped 6")
//            //instantiateViewController
//        }
    }
    
    
}
