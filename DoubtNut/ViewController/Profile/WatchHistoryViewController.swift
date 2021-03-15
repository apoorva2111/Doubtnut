//
//  WatchHistoryViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 13/03/21.
//

import UIKit

class WatchHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var viewHeader: RCustomButton!
    @IBOutlet weak var backRefBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var NoVideosView: UIView!
    @IBOutlet weak var noVideoIcon: UIImageView!
    @IBOutlet weak var noVideoTitleLabel: UILabel!
    @IBOutlet weak var noVideosSubTitleLabel: UILabel!
    @IBOutlet weak var watchtrendingVideosBtnRef: RCustomButton!
    @IBOutlet weak var watchHistoryView: UIView!
    @IBOutlet weak var watchHistoryTableview: UITableView!
    let arrData = ["899999","00900000","900000000"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if arrData.isEmpty {
            print("No History Found")
            watchHistoryView.isHidden = true
            NoVideosView.isHidden = false
            
        }
        else {
            NoVideosView.isHidden = true
            watchHistoryView.isHidden = false
        }
        watchHistoryTableview.register(WatchHistoryTableViewCell.nib(), forCellReuseIdentifier: "WatchHistoryTableViewCell")
        watchHistoryTableview.delegate = self
        watchHistoryTableview.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickDismissVC(_ sender: UIButton) {
//        let story = UIStoryboard(name: "Home", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickTrendingvideos(_ sender: RCustomButton) {
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = watchHistoryTableview.dequeueReusableCell(withIdentifier: "WatchHistoryTableViewCell", for: indexPath) as! WatchHistoryTableViewCell
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
