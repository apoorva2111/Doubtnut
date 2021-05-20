//
//  WatchHistoryViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 13/03/21.
//

import UIKit
import SDWebImage

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
    var arrWatchHistory = [NSDictionary]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        watchHistoryTableview.register(WatchHistoryTableViewCell.nib(), forCellReuseIdentifier: "WatchHistoryTableViewCell")
        watchHistoryTableview.delegate = self
        watchHistoryTableview.dataSource = self
        callWebserviceGetHistory()

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
        return arrWatchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = watchHistoryTableview.dequeueReusableCell(withIdentifier: "WatchHistoryTableViewCell", for: indexPath) as! WatchHistoryTableViewCell
        let objList = arrWatchHistory[indexPath.row]
        let ocrText = objList["ocr_text"] as? String
        cell.lblQuest.text = ocrText?.html2String
        if let imgUrl = objList["question_image"]{
            cell.thumbnailImage.sd_imageIndicator = SDWebImageActivityIndicator.gray

            cell.thumbnailImage.sd_setImage(with: URL(string: imgUrl as! String), completed: nil)
        }

        if let timestamp = objList["timestamp_formatted"]{
            cell.bottomRightLabel.text = timestamp as? String
        }
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

extension WatchHistoryViewController{
    func callWebserviceGetHistory(){
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v1/question/watch-history?page=1")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("844", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                print("Response: \(String(describing: response))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        let jsonString = BaseApi.showParam(json: json)
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api URL:- https://api.doubtnut.app/v1/question/watch-history?page=1", message: "Response: \(jsonString)     version_code:- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            
                            if checkBtn == "OK"{
                                OperationQueue.main.addOperation { [self] in
                                    BaseApi.hideActivirtIndicator()
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? [String:AnyObject]{
                                                print(data)
                                                let list = data["list"] as! NSArray
                                                print(list)
                                                for objList in list{
                                                    arrWatchHistory.append(objList as! NSDictionary)
                                                }
        //
                                                if arrWatchHistory.isEmpty {
                                                    print("No History Found")
                                                    watchHistoryView.isHidden = true
                                                    NoVideosView.isHidden = false
                                                    
                                                }else {
                                                    NoVideosView.isHidden = true
                                                    watchHistoryView.isHidden = false
                                                    watchHistoryTableview.reloadData()
                                                }
                                               
                                                print(arrWatchHistory)
                                            }
                                        }else{
                                            BaseApi.hideActivirtIndicator()
                                        }
                                        
                                    }
                                }
                            }else{
                                BaseApi.hideActivirtIndicator()

                            }
                        }
                        
                    }
                } catch let error {
                    self.showToast(message: "Something Went Wrong")
                    
                    BaseApi.hideActivirtIndicator()
                    
                    print(error.localizedDescription)
                }
            }
        })
        
        task.resume()
    }
}
