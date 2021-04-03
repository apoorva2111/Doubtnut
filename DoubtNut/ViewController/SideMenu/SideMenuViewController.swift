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
    
    
    
    
    var imageArray = [[UIImage(named: "Vector")],[UIImage(named: "ChangeClass"),UIImage(named: "grade")],
                      [UIImage(named: "history"),UIImage(named: "QA"),UIImage(named: "playlist")],
                      [UIImage(named: "payment"),UIImage(named: "settings")]]
  
    var titleArray = [["Login PIN"],["Change Grade","ChangeLanguage"],
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
          //  if indexPath.row == 0 {
                cell.sideMenuImage.isHidden = false
              cell.sideMenuTitle.isHidden = false
                cell.viewLoginPin.isHidden = false
            cell.viewChangeClass.isHidden = true
            cell.viewChangeLanguage.isHidden = true
                cell.changePinOutlt.addTarget(self, action: #selector(changePinAction(_:)), for: .touchUpInside)
            
            cell.sideMenuTitle.text = titleArray[indexPath.section][indexPath.row]

            cell.sideMenuImage.image = imageArray[indexPath.section][indexPath.row]

        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                cell.sideMenuImage.isHidden = false
              cell.sideMenuTitle.isHidden = false
                cell.viewLoginPin.isHidden = true
            cell.viewChangeClass.isHidden = false
            cell.viewChangeLanguage.isHidden = true
              
                if SettingValue.chooseClass == ""{
                    let chooseClass = userDef.string(forKey: UserDefaultKey.chooseClass)
                   
                    cell.lblLanguage.setTitle("(\(String(describing: chooseClass)))", for: .normal)
                }else{
                    cell.lblClass.setTitle("(\(SettingValue.chooseClass))", for: .normal)
                    userDef.setValue(SettingValue.chooseClass, forKey: UserDefaultKey.chooseClass)
                }
                
            
            cell.sideMenuTitle.text = titleArray[indexPath.section][indexPath.row]

            cell.sideMenuImage.image = imageArray[indexPath.section][indexPath.row]
            }else{
                cell.sideMenuImage.isHidden = false
              cell.sideMenuTitle.isHidden = false
                cell.viewLoginPin.isHidden = true
            cell.viewChangeClass.isHidden = true
            cell.viewChangeLanguage.isHidden = false
                cell.changePinOutlt.addTarget(self, action: #selector(changePinAction(_:)), for: .touchUpInside)
                if SettingValue.chooseLanguage == ""{
                    let chooseLange = userDef.string(forKey: UserDefaultKey.chooseLang)
                   
                    cell.lblLanguage.setTitle("(\(String(describing: chooseLange)))", for: .normal)
                }else{
                    cell.lblLanguage.setTitle("(\(SettingValue.chooseLanguage))", for: .normal)
                    userDef.setValue(SettingValue.chooseClass, forKey: UserDefaultKey.chooseLang)
                }

            cell.sideMenuTitle.text = titleArray[indexPath.section][indexPath.row]

            cell.sideMenuImage.image = imageArray[indexPath.section][indexPath.row]
            }
        }
            else {
                cell.viewLoginPin.isHidden = true
                cell.viewChangeClass.isHidden = true
                cell.viewChangeLanguage.isHidden = true
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
        if  indexPath.section == 0{
            if indexPath.row == 0 {
                BoolValue.isFromSideMenuSetPin = true

                let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home") as! DashboardVC
                self.navigationController?.pushViewController(vc, animated: false)

            }
            
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                
//                /SettingValue.chooseClass
                let story = UIStoryboard(name: "Home", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "GetLanguageOrClassVC") as! GetLanguageOrClassVC
                vc.strSelectType = "Class"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1{
                let vc = storyboard?.instantiateViewController(identifier: "GetLanguageOrClassVC") as! GetLanguageOrClassVC
                vc.strSelectType = "Language"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 2{
           
            if indexPath.row == 0 {
            let vc = FlowController().instantiateViewController(identifier:"WatchHistoryViewController", storyBoard: "Profile")
            self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1{
                
                let vc = FlowController().instantiateViewController(identifier:"QuestionAskedViewController", storyBoard: "Profile")
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = FlowController().instantiateViewController(identifier:"WatchHistoryViewController", storyBoard: "Profile")
                self.navigationController?.pushViewController(vc, animated: true)

            }
            
        }else if indexPath.section == 3{
            if indexPath.row == 0{
                
            }else if indexPath.row == 1{
            let mainVC = FlowController().instantiateViewController(identifier: "NavSetting", storyBoard:"Setting")
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = mainVC
            appDel.window?.makeKeyAndVisible()
            }
        }

    }
    
    @objc func changePinAction(_ sender: UIButton){
        BoolValue.isFromSideMenuSetPin = true

        let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home") as! DashboardVC
        self.navigationController?.pushViewController(vc, animated: false)

       
    }
}
