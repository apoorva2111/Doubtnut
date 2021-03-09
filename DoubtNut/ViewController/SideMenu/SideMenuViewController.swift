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
    
    
    var imageArray = [UIImage(named: "Vector"),UIImage(named: "history"),UIImage(named: "QA"),UIImage(named: "playlist"),UIImage(named: "playlist"),UIImage(named: "payment"),UIImage(named: "settings")]
    var titleArray = ["Login PIN ____(Change Pin)","History","Question Asked History","Saved Playlist","Watch Later","Payment History","Settings"]
    
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
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.sideMenuImage.image = imageArray[indexPath.row]
        cell.sideMenuTitle.text = titleArray[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(identifier: "SATVC") as! SATVC
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        else if indexPath.row == 1 {
            print(" is tapped")
            //instantiateViewController
        }
        else if indexPath.row == 2 {
            print(" is tapped")
            //instantiateViewController
        }
        else if indexPath.row == 3 {
            print(" is tapped")
            //instantiateViewController
        }
        else if indexPath.row == 4 {
            print(" is tapped")
            //instantiateViewController
        }
        else if indexPath.row == 5 {
            print(" is tapped")
            //instantiateViewController
        }
        else if indexPath.row == 6 {
            print(" is tapped")
            //instantiateViewController
        }
    }
    
    
}
