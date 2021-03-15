//
//  QuestionAskedViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 14/03/21.
//

import UIKit

class QuestionAskedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var questionAskedView: UIView!
    @IBOutlet weak var questionAskedTableview: UITableView!
    @IBOutlet weak var headerView: RCustomButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var askQuestionRefBtn: UIButton!
    @IBOutlet weak var viewHeaderTitleLabel: UILabel!
    @IBOutlet weak var noVideosView: UIView!
    
    let arrData = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if arrData.isEmpty {
            print("No History Found")
            questionAskedView.isHidden = true
            noVideosView.isHidden = false
            
        }
        else {
            noVideosView.isHidden = true
            questionAskedView.isHidden = false
        }
        
        questionAskedTableview.delegate = self
        questionAskedTableview.dataSource = self
        questionAskedTableview.register(WatchHistoryTableViewCell.nib(), forCellReuseIdentifier: "WatchHistoryTableViewCell")
        askQuestionRefBtn.layer.cornerRadius = 12

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickDismissVC(_ sender: UIButton) {
//        let story = UIStoryboard(name: "Home", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func onClickAskQuestion(_ sender: UIButton) {
        
        let vc = FlowController().instantiateViewController(identifier: "PlayVideoVC", storyBoard: "PlayVideo")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionAskedTableview.dequeueReusableCell(withIdentifier: "WatchHistoryTableViewCell", for: indexPath) as! WatchHistoryTableViewCell
        cell.thumbnailImage.image = #imageLiteral(resourceName: "download")
        cell.bottomRightLabel.text = arrData[indexPath.row]
        cell.durationLabel.text = "10:54"
        cell.viewCountLabel.text = "10K"
        cell.onClickPlay = {
            //action to play video
            print("play button is tapped")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }

}
