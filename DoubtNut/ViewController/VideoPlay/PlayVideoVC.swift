//
//  PlayVideoVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 14/03/21.
//

import UIKit

class PlayVideoVC: UIViewController {
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tblView.register(WatchHistoryTableViewCell.nib(), forCellReuseIdentifier: "WatchHistoryTableViewCell")
        tblView.delegate = self
        tblView.dataSource = self
        // tblView any additional setup after loading the view.
    }
    


}
extension PlayVideoVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "WatchHistoryTableViewCell", for: indexPath) as! WatchHistoryTableViewCell
    //    cell.thumbnailImage.image = #imageLiteral(resourceName: "download")
//        cell.bottomRightLabel.text = arrData[indexPath.row]
//        cell.durationLabel.text = "10:54"
//        cell.viewCountLabel.text = "10K"
//        cell.onClickPlay = {
//            //action to play video
//            print("play button is tapped")
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
}
