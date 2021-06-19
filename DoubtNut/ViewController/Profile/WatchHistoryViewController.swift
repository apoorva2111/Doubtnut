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
    var currentPage : Int = 1
    var checkPagination = ""
    var chapter = ""
    var doubt = ""
    var subject = ""
    var student_id = ""
    var locale = ""
    var ocr_text = ""
    var classs = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        watchHistoryTableview.register(WatchHistoryTableViewCell.nib(), forCellReuseIdentifier: "WatchHistoryTableViewCell")
        watchHistoryTableview.delegate = self
        watchHistoryTableview.dataSource = self
        self.checkPagination = "get"
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objList = arrWatchHistory[indexPath.row]
//        let vc = FlowController().instantiateViewController(identifier: "PlayVideoVC", storyBoard: "PlayVideo") as! PlayVideoVC
//        /**/
//        vc.videDictionary = objList as! NSMutableDictionary
//
//        self.navigationController?.pushViewController(vc, animated: true)
        if let chapter = objList["chapter"]{
            self.chapter  = chapter as! String
        }
        if let doubt = objList["doubt"]{
            self.doubt = doubt as! String
        }
        if let subject = objList["subject"]{
            self.subject = subject as! String
        }
        if let student_id = objList["student_id"]{
            self.student_id = String(student_id as! Int)
        }
        if let locale = objList["locale"]{
            self.locale = locale as! String
        }
        
        if let ocr_text = objList["ocr_text"]{
            self.ocr_text = ocr_text as! String
        }
        if let classs = objList["class"]{
            self.classs = classs as! String
        }
        callWebserviceForAskQues(chapter: self.chapter, doubt: doubt, subject: subject, student_id: student_id, locale: locale, ocr_text: ocr_text, classs: classs)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                if indexPath.row == arrWatchHistory.count-1{
                    self.checkPagination = "pagination"
                    currentPage += 1
                    run(after: 2) {
                        self.callWebserviceGetHistory()
                    }
                }
            }
        }
    }
}

extension WatchHistoryViewController{
    func callWebserviceGetHistory(){
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v1/question/watch-history?page=\(currentPage)")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzY5NDQ5OTgsImlhdCI6MTYyMDkwMzY4MSwiZXhwIjoxNjgzOTc1NjgxfQ.KTRsKuo07iRgVEjiCuO8HwV4ZdDZzkVjZix2sMqZt00", forHTTPHeaderField: "x-auth-token")
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
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api URL:- https://api.doubtnut.app/v1/question/watch-history?page=\(self.currentPage)", message: "Response: \(jsonString)     version_code:- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            
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
                                                if self.checkPagination == "get"{
                                                    self.arrWatchHistory.removeAll()
                                                  
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
                                                }else{
                                                    for objList in list{
                                                        arrWatchHistory.append(objList as! NSDictionary)
                                                    }
                                                    if list.count == 0 {
                                                        print("No History Found")
                                                    }else {
                                                        NoVideosView.isHidden = true
                                                        watchHistoryView.isHidden = false
                                                        watchHistoryTableview.reloadData()
                                                    }
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
    
    
    func callWebserviceForAskQues(chapter:String,doubt:String,subject:String,student_id:String,locale:String,ocr_text:String,classs:String) {
        
//
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let parameters = [
            "chapter": chapter,
            "colorVersion": 2,
            "question": doubt,
            "other_multiple_images_selected": false,
            "subject": subject,
            "checkExactMatch": false,
            "student_id": student_id,
            "topicsPosition": 0,
            "source": "",
            "locale": locale,
            "question_text": ocr_text,
            "clientSource": "app",
            "image_ocr_feedback": "",
            "question_image": "image_url",
            "supported_media_type": [ "DASH", "HLS", "RTMP", "BLOB" ],
            "topic": "test",
            "class": classs,
            "uploaded_image_name": ""] as [String : Any]
        
        //create the url with URL
        print(parameters)
        let url = URL(string: "https://api.doubtnut.com/v10/questions/ask")! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("776", forHTTPHeaderField: "version_code")
    

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    let jsonString = BaseApi.showParam(json: json)
                    let param = BaseApi.showParam(json: parameters)
                    UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param),  URL:- https://api.doubtnut.com/v10/questions/ask", message: "Response: \(jsonString)     version_code:- 776", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK"{
                            
                            if let meta = json["meta"] as? [String:AnyObject]{
                                let code = meta["code"] as! Int
                                if code == 200 {
                                    // create the alert
                                    OperationQueue.main.addOperation {
                                        BaseApi.hideActivirtIndicator()
                                        
                                        if let data = json["data"] as? [String:AnyObject]{
//                                            self.txtSearchQues.resignFirstResponder()
                                            let vc = FlowController().instantiateViewController(identifier: "VIdeoListVC", storyBoard: "Home") as! VIdeoListVC
                                            vc.arrAskQuestion = data
                                            vc.questionstring = ocr_text
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                                  //  }
                                }else{
                                    OperationQueue.main.addOperation {
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }
                        }else{
                            BaseApi.hideActivirtIndicator()

                        }
                    }
            
                    // handle json..
                        
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
