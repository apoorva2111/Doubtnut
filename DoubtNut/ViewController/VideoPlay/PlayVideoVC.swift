//
//  PlayVideoVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 14/03/21.
//

import UIKit
import AVKit

class PlayVideoVC: UIViewController {
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewPlayVideo: AGVideoPlayerView!
    @IBOutlet weak var imgQuestion: UIImageView!
    @IBOutlet weak var lblQuestionDescription: UILabel!
    @IBOutlet weak var imgQuestionHeightConstraint: NSLayoutConstraint!
  
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblDislike: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!

    
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var btnDislikeOutlet: UIButton!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgDislike: UIImageView!
    
    
    var videourl : URL?
    var previewimage : URL?
    var videDictionary = NSMutableDictionary()
   // var quesID = ""
    var arrList = [NSMutableDictionary]()
    var arrDislikeContent = [NSMutableDictionary]()
    
    var answer_video = ""
    var view_id = ""
    var question_id = ""
    var answer_id = ""
    var likeCount = 0
    var dislikeCount = 0
    var shareCount = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       print(videDictionary)
        tblView.register(UINib.init(nibName: "ResultTVCell", bundle: nil), forCellReuseIdentifier: "ResultTVCell")
        tblView.delegate = self
        tblView.dataSource = self
        
        if let id  = videDictionary["question_id"] as? Int{
            callWebserviceForQuestionPlay(quesID: String(id))
        }
    }
}
//MARK:- UIButton Action
extension PlayVideoVC{
    @IBAction func btnDropDownAcion(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgQuestion.isHidden = true
            imgQuestionHeightConstraint.constant = 0
            self.lblQuestionDescription.numberOfLines = 1

        }else{
            sender.isSelected = true
            if imgQuestion.image != nil{
                imgQuestion.isHidden = false
                imgQuestionHeightConstraint.constant = 150
                self.lblQuestionDescription.numberOfLines = 0

            }
        }
    }
    @IBAction func btnLikeAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            webserviceCallForLike(feedback: "", answer_video: answer_video, view_id: view_id, rating: "3", question_id: question_id, answer_id:answer_id)

        }else{
            sender.isSelected = true
            webserviceCallForLike(feedback: "", answer_video: answer_video, view_id: view_id, rating: "5", question_id: question_id, answer_id:answer_id)

        }
    }
    @IBAction func btnDislikeAction(_ sender: UIButton) {
        callWebserviceForGetDislikeContant()
    }
    @IBAction func btnCommentAction(_ sender: UIButton) {
    }
    @IBAction func btnShareAction(_ sender: UIButton) {
        let url  = NSURL(string: "whatsapp://send?text=Hello%20Friends%2C%20Sharing%20some%20data%20here...%20!")

        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"

        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:]) { (success) in
                        if success {
                            print("WhatsApp accessed successfully")
                        } else {
                            print("Error accessing WhatsApp")
                        }
                    }
            }
    }
    
    @IBAction func btnWatchLaterAction(_ sender: UIButton) {
        callWebserviceForPlaylistWrapper()
    }
}


extension PlayVideoVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "ResultTVCell", for: indexPath) as! ResultTVCell
        
        cell.setCellData(Dict: arrList[indexPath.row])
  
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // question_id
       let objDict =  arrList[indexPath.row]
        if let id = objDict["question_id"] as? String{
            callWebserviceForQuestionPlay(quesID: String(id))
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PlayVideoVC {
    func callWebserviceForQuestionPlay(quesID:String) {
        
        var studentID = ""
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        if let studentId = userDef.value(forKey: "student_id") as? Int{
            
            studentID = String(studentId)
        }
        let parameters = [ "is_from_topic_booster": false,
                           "jws_token": "",
                           "mc_class": "",
                           "student_id": studentID,
                           "mc_id": "",
                           "source": "ios_us",
                           "mc_course": "",
                           "tab_id": "0",
                           "parent_id": "0",
                           "has_play_service": false,
                           "supported_media_type": [ "DASH", "HLS", "RTMP", "BLOB", "YOUTUBE" ],
                           "id": quesID,
                           "page": "LIBRARY",
                           "is_emulator": false ]
            as [String : Any]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.com/v13/answers/view-answer-by-question-id")! //change the url
        
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
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzY5NDQ5OTgsImlhdCI6MTYyMDkwMzY4MSwiZXhwIjoxNjgzOTc1NjgxfQ.KTRsKuo07iRgVEjiCuO8HwV4ZdDZzkVjZix2sMqZt00", forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("845", forHTTPHeaderField: "version_code")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // BaseApi.hideActivirtIndicator()
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
                    let param = BaseApi.showParam(json: parameters)
                    let jsonString = BaseApi.showParam(json: json)
                    OperationQueue.main.addOperation {
                        UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param), URL:- https://api.doubtnut.com/v13/answers/view-answer-by-question-id", message: "Response: \(jsonString)     version_code:- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (clickButton) in
                            
                            if clickButton == "OK" {
                                BaseApi.hideActivirtIndicator()
                                
                                if let meta = json["meta"] as? [String:AnyObject]{
                                    let code = meta["code"] as! Int
                                    BaseApi.hideActivirtIndicator()
                                    
                                    if code == 200 {
                                        BaseApi.hideActivirtIndicator()
                                        if let data = json["data"] as? [String:AnyObject]{
                                            
                                            if let answer_video = data["answer_video"] {
                                                self.answer_video = answer_video as! String
                                            }
                                            if let view_id = data["view_id"] as? Int{
                                                self.view_id = String(view_id)
                                            }
                                            if let question_id = data["question_id"] as? Int{
                                                self.question_id = String(question_id)
                                            }
                                            
                                            if let answer_id = data["answer_id"] as? Int{
                                                self.answer_id = String(answer_id)
                                            }
                                            if let videoDiscription = data["ocr_text"] as? String{
                                                print(videoDiscription)
                                                
                                                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                                                let matches = detector.matches(in: videoDiscription, options: [], range: NSRange(location: 0, length: videoDiscription.utf16.count))
                                                
                                                for match in matches {
                                                    guard let range = Range(match.range, in: videoDiscription) else { continue }
                                                    let url = videoDiscription[range]
                                                    print(url)
                                                    if url == "" {
                                                        self.imgQuestion.isHidden = true
                                                        self.imgQuestionHeightConstraint.constant = 0
                                                    }else{
                                                        self.imgQuestion.isHidden = false
                                                        self.imgQuestion.sd_setImage(with: URL.init(string: String(url)), completed: nil)
                                                        self.imgQuestionHeightConstraint.constant = 0
                                                        
                                                    }
                                                }
                                                if matches.count == 0 {
                                                    self.imgQuestion.isHidden = true
                                                }
                                                self.lblQuestionDescription.numberOfLines = 2
                                                self.lblQuestionDescription.text = videoDiscription.html2String.trimmingCharacters(in: .whitespacesAndNewlines)
                                                
                                                
                                            }
                                            if let dislikes_count = data["dislikes_count"] as? Int{
                                                self.dislikeCount = dislikes_count
                                                self.lblDislike.text = String(dislikes_count)
                                            }
                                            if let isLiked = data["isLiked"] as? Int{
                                                if isLiked == 1{
                                                    self.btnLikeOutlet.isSelected = true
                                                    self.imgLike.image = #imageLiteral(resourceName: "Like_Active")
                                                }else{
                                                    self.btnLikeOutlet.isSelected = false
                                                    self.imgLike.image = #imageLiteral(resourceName: "Like")
                                                }
                                            }
                                            if let isLiked = data["isDisliked"] as? Int{
                                                if isLiked == 1{
                                                    self.btnDislikeOutlet.isSelected = true
                                                    self.imgDislike.image = #imageLiteral(resourceName: "Dislike_Active")
                                                }else{
                                                    self.btnDislikeOutlet.isSelected = false
                                                    self.imgDislike.image = #imageLiteral(resourceName: "Dislike")
                                                }
                                            }
                                            if let share_count = data["share_count"] as? Int{
                                                self.lblShare.text = String(share_count)
                                                self.shareCount = share_count
                                            }
                                            if let likes_count = data["likes_count"] as? Int{
                                                self.lblLike.text = String(likes_count)
                                                self.likeCount = likes_count
                                            }
                                            if let videoLink = data["fallback_answer_video"] as? String{
                                                self.videourl = URL.init(string: videoLink)
                                                self.viewPlayVideo.videoUrl = self.videourl
                                                self.viewPlayVideo.previewImageUrl = self.previewimage
                                                self.viewPlayVideo.shouldAutoplay = true
                                                self.viewPlayVideo.shouldAutoRepeat = true
                                                self.viewPlayVideo.showsCustomControls = false
                                                self.viewPlayVideo.shouldSwitchToFullscreen = false
                                                self.viewPlayVideo.shouldHideToolbarPlaceholder = false
                                                
                                            }
                                            
                                            if let id  = data["question_id"] as? Int{
                                                let view_id = data["view_id"]
                                                
                                                self.webserviceforSimilarQuestion(quesID: String(id), view_id: view_id as! Int)
                                            }
                                        }else{
                                            if let id  = self.videDictionary["question_id"] as? Int{
                                                self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                            }
                                        }
                                        
                                    }else if code == 401{
                                        BaseApi.hideActivirtIndicator()
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                        }
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                    }else if code == 500 {
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                            if let id  = self.videDictionary["question_id"] as? Int{
                                                self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                            }
                                        }
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }else{
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }else{
                                if let id  = self.videDictionary["question_id"] as? Int{
                                    self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                }
                                
                                BaseApi.hideActivirtIndicator()
                                
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        /*
         answer_video
         "view_id"
         question_id
         answer_id
         
         
         ["meta": {
         analytics =     {
         "variant_info" =         (
         {
         "flag_name" = "ads_combined_experiment";
         "variant_id" = 1018;
         }
         );
         };
         code = 200;
         message = SUCCESS;
         success = 1;
         }, "data": {
         "answer_feedback" = "";
         "answer_id" = 2260067;
         "answer_rating" = 1;
         "answer_video" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1590409621_147177403/answer-1590409621_147177403-master-playlist.m3u8";
         "aspect_ratio" = "16:9";
         "avg_view_time" = 8;
         "block_forwarding" = 0;
         "block_screenshot" = 0;
         "bottom_view" = SIMILAR;
         chapter = "3- SHAPES";
         class = 10;
         "comment_count" = 0;
         "connect_firebase" = 0;
         "connect_socket" = 0;
         description = "<img src=\"https://d10lpgp6xz60nq.cloudfront.net/physics_images/KPL_SAT_MAT_PRP_PS_15_E01_001_Q01.png\" width=\"80%\"> <br> A flooring company stores its marble tiles in vertical stacks as shown above. Each tile measures 18''`times`18''`times(1)/(2)`''. How many cubic feet of tile are there in one stack of 48 of these tiles?";
         "dislikes_count" = 5;
         doubt = "KPL_SAT_MAT_PRP_PS_15_E01_001";
         "download_url" = "<null>";
         exam = SAT;
         "expert_id" = 10714;
         "fallback_answer_video" = "https://doubtnut.s.llnwi.net/answer-1590409621_147177403.mp4";
         "hls_timeout" = 0;
         id = 147177403;
         isDisliked = 0;
         isLiked = 1;
         isPlaylistAdded = 0;
         "is_approved" = 1;
         "is_dn_video" = 1;
         "is_premium" = 1;
         "is_shareable" = 1;
         "is_vip" = 1;
         "is_youtube" = 0;
         "likes_count" = 59;
         "log_data" =     {
         chapter = "3- SHAPES";
         subject = MATHS;
         "type_of_content" = SF;
         "video_language" = English;
         "video_locale" = en;
         };
         "min_watch_time" = 0;
         "moe_event" =     {
         "video_locale" = en;
         };
         "ocr_text" = "<img src=\"https://d10lpgp6xz60nq.cloudfront.net/physics_images/KPL_SAT_MAT_PRP_PS_15_E01_001_Q01.png\" width=\"80%\"> <br> A flooring company stores its marble tiles in vertical stacks as shown above. Each tile measures 18\\'\\'`times`18\\'\\'`times(1)/(2)`\\'\\'. How many cubic feet of tile are there in one stack of 48 of these tiles?";
         "payment_deeplink" = "doubtnutapp://billing_info";
         question = "<img src=\"https://d10lpgp6xz60nq.cloudfront.net/physics_images/KPL_SAT_MAT_PRP_PS_15_E01_001_Q01.png\" width=\"80%\"> <br> A flooring company stores its marble tiles in vertical stacks as shown above. Each tile measures 18''`times`18''`times(1)/(2)`''. How many cubic feet of tile are there in one stack of 48 of these tiles?";
         "question_id" = 147177403;
         "question_meta" =     {
         "aptitude_type" = "<null>";
         "assigned_to" = 10714;
         "audio_quality" = "<null>";
         chapter = "SURFACE AREAS AND VOLUMES";
         "chapter_type" = "<null>";
         class = 10;
         "concept_type" = "<null>";
         "diagram_type" = "<null>";
         "doubtnut_recommended" = "<null>";
         "ei_type" = "<null>";
         id = 4968780;
         "intern_id" = 10714;
         "is_skipped" = 0;
         language = "<null>";
         level = "<null>";
         "mc_text" = Cuboid;
         "meta_tags" = "<null>";
         microconcept = "CV_1162";
         "ocr_quality" = "<null>";
         p = "<null>";
         package = "<null>";
         packages = "<null>";
         "pfs_type" = "<null>";
         "q_answer" = "<null>";
         "q_options" = "<null>";
         "question_id" = 147177403;
         "questions_title" = "<null>";
         "secondary_chapter" = "<null>";
         "secondary_class" = "<null>";
         "secondary_mc_text" = "<null>";
         "secondary_microconcept" = "<null>";
         "secondary_subtopic" = "<null>";
         subject = "<null>";
         subtopic = INTRODUCTION;
         "symbol_type" = "<null>";
         "target_course" = "<null>";
         timestamp = "2020-05-22T21:51:57.000Z";
         type = "<null>";
         "video_quality" = "<null>";
         "we_type" = "<null>";
         };
         "resource_data" = "<null>";
         "resource_type" = video;
         "share_count" = 156999;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "show_replay_quiz" = 1;
         "student_id" = "-40";
         "thumbnail_image" = "https://doubtnut-static.s.llnwi.net/static/question-thumbnail/en_147177403.png";
         title = "<img src=\"https://d10lpgp6xz60nq.cloudfront.net/physics_images/KPL_SAT_MAT_PRP_PS_15_E01_001_Q01.png\" width=\"80%\"> <br> A flooring company stores its marble tiles in vertical stacks as shown above. Each tile measures 18''`times`18''`times(1)/(2)`''. How many cubic feet of tile are there in one stack of 48 of these tiles?";
         "topic_video_text" = "";
         "total_views" = 0;
         type = answered;
         "use_fallback" = 1;
         "video_name" = "answer-1590409621_147177403.mp4";
         "video_page_iteration" = 1;
         "video_resources" =     (
         {
         
         "drm_license_url" = "";
         "drm_scheme" = widevine;
         "drop_down_list" =             (
         );
         "media_type" = BLOB;
         offset = "<null>";
         resource = "https://doubtnut.s.llnwi.net/answer-1590409621_147177403.mp4";
         timeout = 4;
         }
         );
         "view_id" = 1610487515;
         weburl = "https://doubtnut.com/question-answer/a-flooring-company-stores-its-marble-tiles-in-vertical-stacks-as-shown-above-each-tile-measures-18ti-147177403";
         "youtube_id" = "<null>";
         }]
         */
    }
    func webserviceforSimilarQuestion(quesID:String, view_id:Int) {
        
        var playlistID = ""
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        
        if let studentId = userDef.value(forKey: "playlist_id") as? String{
            
            playlistID = String(studentId)
        }
        let parameters = [ "ias_similar_widget": false,
                           "playlist_id": playlistID,
                           "parent_id": "0",
                           "mc_id": "",
                           "page": "SIMILAR",
                           "question_id": quesID ]as [String : Any]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v11/answers/view-similar-questions")! //change the url
        
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
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzY5NDQ5OTgsImlhdCI6MTYyMDkwMzY4MSwiZXhwIjoxNjgzOTc1NjgxfQ.KTRsKuo07iRgVEjiCuO8HwV4ZdDZzkVjZix2sMqZt00", forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("845", forHTTPHeaderField: "version_code")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // BaseApi.hideActivirtIndicator()
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
                    let param = BaseApi.showParam(json: parameters)
                    let jsonString = BaseApi.showParam(json: json)
                    OperationQueue.main.addOperation {
                        BaseApi.hideActivirtIndicator()
                        UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param), URL:- https://api.doubtnut.com/v13/answers/view-answer-by-question-id", message: "Response: \(jsonString)     version_code:- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (clickButton) in
                            
                            if clickButton == "OK" {
                                BaseApi.hideActivirtIndicator()
                                if let meta = json["meta"] as? [String:AnyObject]{
                                    let code = meta["code"] as! Int
                                    BaseApi.hideActivirtIndicator()
                                    
                                    if code == 200 {
                                        BaseApi.hideActivirtIndicator()
                                        if let data = json["data"] as? [String:AnyObject]{
                                            print(data)
                                            if let similorVideoarr = data["similar_video"] as? NSArray{
                                                if self.arrList.count>0{
                                                    self.arrList.removeAll()
                                                }
                                                for obj in similorVideoarr {
                                                    self.arrList.append(obj as! NSMutableDictionary)
                                                }
                                                if self.arrList.count>0 {
                                                    self.tblView.isHidden = false
                                                    self.tblView.reloadData()
                                                }else{
                                                    self.tblView.isHidden = true
                                                }
                                            }
                                            if view_id != 0{
                                                self.webserviceforUpdatedAnserView(viewID: String(view_id))
                                            }
                                        }
                                        
                                    }else if code == 401{
                                        BaseApi.hideActivirtIndicator()
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                        }
                                    }else if code == 500 {
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                        }
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }else{
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }else{
                                BaseApi.hideActivirtIndicator()
                                
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    func webserviceforUpdatedAnserView(viewID:String) {
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        let parameters = [ "is_back": "0",
                           "video_time": "8",
                           "engage_time": "8",
                           "is_scheduled_task": false,
                           "view_id": viewID]as [String : Any]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v10/answers/update-answer-view")! //change the url
        
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
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzY5NDQ5OTgsImlhdCI6MTYyMDkwMzY4MSwiZXhwIjoxNjgzOTc1NjgxfQ.KTRsKuo07iRgVEjiCuO8HwV4ZdDZzkVjZix2sMqZt00", forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("845", forHTTPHeaderField: "version_code")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // BaseApi.hideActivirtIndicator()
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
                    let param = BaseApi.showParam(json: parameters)
                    let jsonString = BaseApi.showParam(json: json)
                    OperationQueue.main.addOperation {
                        BaseApi.hideActivirtIndicator()
                        UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param), URL:- https://api.doubtnut.com/v13/answers/view-answer-by-question-id", message: "Response: \(jsonString)     version_code:- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (clickButton) in
                            
                            if clickButton == "OK" {
                                BaseApi.hideActivirtIndicator()
                                if let meta = json["meta"] as? [String:AnyObject]{
                                    let code = meta["code"] as! Int
                                    BaseApi.hideActivirtIndicator()
                                    
                                    if code == 200 {
                                        BaseApi.hideActivirtIndicator()
                                        if let data = json["data"] as? [String:AnyObject]{
                                            print(data)
                                        }
                                        
                                    }else if code == 401{
                                        BaseApi.hideActivirtIndicator()
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                        }
                                    }else if code == 500 {
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                        }
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }else{
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }else{
                                BaseApi.hideActivirtIndicator()
                                
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    func webserviceCallForLike(feedback:String,answer_video:String,view_id:String,rating:String,question_id:String,answer_id:String){
        
        //If dislike Rating = 0
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        let parameters = ["feedback": feedback, "answer_video": answer_video, "view_id": view_id, "rating": rating, "view_time": "11", "page": "LIBRARY", "question_id": question_id, "answer_id": answer_id]
            as [String : Any]
        print(parameters)
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.com/v4/feedback/video-add")! //change the url
        
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
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzY5NDQ5OTgsImlhdCI6MTYyMDkwMzY4MSwiZXhwIjoxNjgzOTc1NjgxfQ.KTRsKuo07iRgVEjiCuO8HwV4ZdDZzkVjZix2sMqZt00", forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("845", forHTTPHeaderField: "version_code")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // BaseApi.hideActivirtIndicator()
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
                    let param = BaseApi.showParam(json: parameters)
                    let jsonString = BaseApi.showParam(json: json)
                    OperationQueue.main.addOperation {
                        UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param), URL:- https://api.doubtnut.com/v4/feedback/video-add", message: "Response: \(jsonString)     version_code:- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (clickButton) in
                            
                            if clickButton == "OK" {
                                BaseApi.hideActivirtIndicator()
                                
                                if let meta = json["meta"] as? [String:AnyObject]{
                                    let code = meta["code"] as! Int
                                    BaseApi.hideActivirtIndicator()
                                    
                                    if code == 200 {
                                        if feedback == ""{
                                            if rating == "5"{
                                                self.likeCount += 1
                                                self.lblLike.text = String(self.likeCount)
                                                self.imgLike.image = #imageLiteral(resourceName: "Like_Active")
                                                self.btnLikeOutlet.isSelected = true
                                            }else{
                                                self.likeCount -= 1
                                                self.lblLike.text = String(self.likeCount)
                                                self.imgLike.image = #imageLiteral(resourceName: "Like")
                                                self.btnLikeOutlet.isSelected = false
                                                
                                            }
                                            
                                        }else{
                                            if rating == "3"{
                                                self.likeCount -= 1
                                                self.lblDislike.text = String(self.dislikeCount)
                                                self.imgDislike.image = #imageLiteral(resourceName: "Dislike")
                                                self.btnDislikeOutlet.isSelected = false
                                            }else{
                                                
                                                self.likeCount += 1
                                                self.lblLike.text = String(self.dislikeCount)
                                                self.imgLike.image = #imageLiteral(resourceName: "Like_Active")
                                                self.btnDislikeOutlet.isSelected = true
                                                
                                                
                                            }
                                            
                                        }
                                        BaseApi.hideActivirtIndicator()
                                        
                                    }else if code == 401{
                                        BaseApi.hideActivirtIndicator()
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                        }
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                    }else if code == 500 {
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                            if let id  = self.videDictionary["question_id"] as? Int{
                                                self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                            }
                                        }
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }else{
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }else{
                                if let id  = self.videDictionary["question_id"] as? Int{
                                    self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                }
                                
                                BaseApi.hideActivirtIndicator()
                                
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        /*
         
         */
    }
    func callWebserviceForGetDislikeContant() {
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.com/v1/feedback/video-dislike-options?source=video")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("845", forHTTPHeaderField: "version_code")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzY5NDQ5OTgsImlhdCI6MTYyMDkwMzY4MSwiZXhwIjoxNjgzOTc1NjgxfQ.KTRsKuo07iRgVEjiCuO8HwV4ZdDZzkVjZix2sMqZt00", forHTTPHeaderField: "x-auth-token")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                print("Response: \(String(describing: response))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        OperationQueue.main.addOperation {
                            BaseApi.hideActivirtIndicator()
                            
                            if let meta = json["meta"] as? [String:AnyObject]{
                                let code = meta["code"] as! Int
                                if code == 200 {
                                    if let data = json["data"] as? NSArray{
                                        if self.arrDislikeContent.count>0{
                                            self.arrDislikeContent.removeAll()
                                        }
                                        for obj in data {
                                            self.arrDislikeContent.append(obj as! NSMutableDictionary)
                                        }
                                        self.OpenActionSheet()
                                    }else{
                                        BaseApi.hideActivirtIndicator()
                                    }
                                    
                                    //
                                }else{
                                    BaseApi.hideActivirtIndicator()
                                    
                                }
                                
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
    func OpenActionSheet() {
        let alertController = UIAlertController(title: "Doubtnut", message: "What didn't you like", preferredStyle: .actionSheet)
        for obj in arrDislikeContent {
            let content = obj["content"] as! String
            let action1 = UIAlertAction(title: content, style: .default) { (action) in
                print("Default is pressed.....\(content)")
                if self.btnDislikeOutlet.isSelected{
                    self.btnDislikeOutlet.isSelected = false
                    self.webserviceCallForLike(feedback: content, answer_video: self.answer_video, view_id: self.view_id, rating: "3", question_id: self.question_id, answer_id:self.answer_id)
                    
                }else{
                    self.btnDislikeOutlet.isSelected = true
                    self.webserviceCallForLike(feedback: content, answer_video: self.answer_video, view_id: self.view_id, rating: "0", question_id: self.question_id, answer_id:self.answer_id)
                    
                }
            }
            
            alertController.addAction(action1)
        }
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func callWebserviceForPlaylistWrapper()  {
        
        //If dislike Rating = 0
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
        var arrPlaylist = [String]()
        var studentID = ""
        
        if let studentId = userDef.value(forKey: "playlist_id") as? String{
            arrPlaylist.append(String(studentId))
        }
        
        if let studentId = userDef.value(forKey: "student_id") as? Int{
            
            studentID = String(studentId)
        }
        let parameters = ["playlist_id": arrPlaylist, "student_id": studentID, "question_id": question_id]
            as [String : Any]
        print(parameters)
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v2/playlist/playlistWrapper")! //change the url
        
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
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzY5NDQ5OTgsImlhdCI6MTYyMDkwMzY4MSwiZXhwIjoxNjgzOTc1NjgxfQ.KTRsKuo07iRgVEjiCuO8HwV4ZdDZzkVjZix2sMqZt00", forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("845", forHTTPHeaderField: "version_code")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // BaseApi.hideActivirtIndicator()
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
                    let param = BaseApi.showParam(json: parameters)
                    let jsonString = BaseApi.showParam(json: json)
                    OperationQueue.main.addOperation {
                        UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param), URL:- https://api.doubtnut.com/v2/playlist/playlistWrapper", message: "Response: \(jsonString)     version_code:- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (clickButton) in
                            
                            if clickButton == "OK" {
                                BaseApi.hideActivirtIndicator()
                                
                                if let meta = json["meta"] as? [String:AnyObject]{
                                    let code = meta["code"] as! Int
                                    BaseApi.hideActivirtIndicator()
                                    
                                    if code == 200 {
                                      
                                        BaseApi.hideActivirtIndicator()
                                        self.showToast(message: "Video Save to Watch Later")
                                        
                                    }else if code == 401{
                                        BaseApi.hideActivirtIndicator()
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                        }
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                    }else if code == 500 {
                                        if let msg = meta["message"] as? String{
                                            self.showToast(message: msg)
                                            if let id  = self.videDictionary["question_id"] as? Int{
                                                self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                            }
                                        }
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }else{
                                        if let id  = self.videDictionary["question_id"] as? Int{
                                            self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                        }
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }else{
                                if let id  = self.videDictionary["question_id"] as? Int{
                                    self.webserviceforSimilarQuestion(quesID: String(id), view_id: 0)
                                }
                                
                                BaseApi.hideActivirtIndicator()
                                
                            }
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        /*
         
         */
    }
}


