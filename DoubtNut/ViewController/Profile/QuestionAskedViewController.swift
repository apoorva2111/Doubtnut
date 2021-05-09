//
//  QuestionAskedViewController.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 14/03/21.
//

import UIKit
import SDWebImage

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
    
    var arrData = [NSDictionary]()
    
    
    
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
        questionVideo(url: "https://api.doubtnut.com/v1/question/watch-history?page=1")
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
        let arrObj = arrData[indexPath.row]
        let quesId = arrObj["question_id"] as! Int
        let question_image = arrObj["question_image"] as? String
        cell.thumbnailImage.sd_imageIndicator = SDWebImageActivityIndicator.gray

        cell.thumbnailImage.sd_setImage(with: URL(string: question_image ?? ""), completed: nil)

        cell.bottomRightLabel.text = String(quesId)
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

//MARK - Call Webservice

extension QuestionAskedViewController{
    func questionVideo(url: String){
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("862", forHTTPHeaderField: "version_code")
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
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api", message: "Response: \(jsonString)", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? NSDictionary{
                                                let objData = data["list"] as!NSArray
                                                for objList in objData {
                                                    arrData.append(objList as! NSDictionary)
                                                }
                                                if arrData.isEmpty {
                                                    print("No History Found")
                                                    questionAskedView.isHidden = true
                                                    noVideosView.isHidden = false
                                                    
                                                }
                                                else {
                                                    noVideosView.isHidden = true
                                                    questionAskedView.isHidden = false
                                                }
                                                questionAskedTableview.reloadData()
                                                
                                                BaseApi.hideActivirtIndicator()
                                                
                                            }else{
                                                BaseApi.hideActivirtIndicator()
                                            }
                                            
                                            //
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
