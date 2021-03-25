//
//  SavedPlaylistViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 13/03/21.
//

import UIKit

class SavedPlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var SavedPlaylistView: UIView!
    @IBOutlet weak var savedPlaylistTableView: UITableView!
    @IBOutlet weak var viewHeader: RCustomButton!
    @IBOutlet weak var NoVideoView: UIView!
    @IBOutlet weak var noVideoImage: UIImageView!
    @IBOutlet weak var noVideoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtnRef: UIButton!
    let arrData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if arrData.isEmpty {
            print("No History Found")
            SavedPlaylistView.isHidden = true
            NoVideoView.isHidden = false
            
        }
        else {
            NoVideoView.isHidden = true
            SavedPlaylistView.isHidden = false
        }
        savedPlaylistTableView.register(WatchHistoryTableViewCell.nib(), forCellReuseIdentifier: "WatchHistoryTableViewCell")
        savedPlaylistTableView.delegate = self
        savedPlaylistTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickDismissView(_ sender: UIButton) {
//        let story = UIStoryboard(name: "Home", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedPlaylistTableView.dequeueReusableCell(withIdentifier: "WatchHistoryTableViewCell", for: indexPath) as! WatchHistoryTableViewCell
        cell.thumbnailImage.image = #imageLiteral(resourceName: "download")
        cell.bottomRightLabel.text = arrData[indexPath.row]
//        cell.durationLabel.text = "10:54"
//        cell.viewCountLabel.text = "10K"
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
