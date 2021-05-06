//
//  FindNewSolutionGifVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 12/03/21.
//

import UIKit
import Lottie
 

class FindNewSolutionGifVC: UIViewController {
    var animation: AnimationView!

    @IBOutlet weak var viewShowGif: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgForSearch: UIImageView!
    
    var imgUploadURL = ""
    var file_name = ""
    var question_id = 0
    var imgUpload : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.batteryLevelChanged),
            name: NSNotification.Name(rawValue: "NotificationIdentifier"),
            object: nil)
        // Do any additional setup after loading the view.
        
        imgForSearch.image = imgUpload
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // your code here
            
            self.upload(image: self.imgUpload, urlString: self.imgUploadURL, mimeType: ".png") { (isTrue, error) in
                print(isTrue)
                if isTrue{
                   // UtilesSwift.shared.showAlert(text: "Image Successfully Uploaded", icon: "")
                    self.callWebserviceForAskQues()
                }else{
                    self.showToast(message: "Something Went Worng")
                }
                print(error ?? "")
            }
        }
    }
    @objc private func batteryLevelChanged(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        playAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playAnimation()

    }
    
    func playAnimation(){
        
        if animation != nil{
            animation.removeFromSuperview()
        }
        animation = AnimationView.init(name: "loader_1")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        
        self.viewShowGif.addSubview(animation)
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.topAnchor.constraint(equalTo: self.viewShowGif.topAnchor).isActive = true
        animation.bottomAnchor.constraint(equalTo: self.viewShowGif.bottomAnchor).isActive = true
        animation.leadingAnchor.constraint(equalTo: self.viewShowGif.leadingAnchor, constant: 0).isActive = true
        animation.trailingAnchor.constraint(equalTo: self.viewShowGif.trailingAnchor, constant: 0).isActive = true
        print(animation.frame)
        animation.play()
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK- Upload image
extension FindNewSolutionGifVC{
    
    func upload(data: Data, urlString: String, mimeType: String, completion: @escaping (Bool, Error?) -> Void) {
        let requestURL = URL(string: urlString)!
        let client = AFHTTPSessionManager(baseURL: requestURL)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        
        let task = client.dataTask(with: request,uploadProgress: nil, downloadProgress: nil, completionHandler: { (response, responseObject, error) in
            print(response ?? "response nil")
            print(responseObject)
            print(error ?? "response nil")
            completion(error == nil, error)
        })
        task.resume()
    }
        
    func upload(image: UIImage, urlString: String, mimeType: String, completion: @escaping (Bool, Error?) -> Void) {
        let data = image.jpegData(compressionQuality: 0.9)!
        upload(data: data, urlString: urlString, mimeType: mimeType, completion: completion)
    }
    
    func callWebserviceForAskQues() {
        
//question_text
        let parameters = ["question_image":"image_url",
                          "uploaded_image_name":file_name,
                          "question":"IOS",
                          "limit":"20",
                          "uploaded_image_question_id":question_id] as [String : Any]
        
        //create the url with URL
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

                   
                    if let meta = json["meta"] as? [String:AnyObject]{
                        let code = meta["code"] as! Int
                        if code == 200 {
                            // create the alert
                            OperationQueue.main.addOperation {
                                BaseApi.hideActivirtIndicator()
                                if let data = json["data"] as? [String:AnyObject]{
                                    let vc = FlowController().instantiateViewController(identifier: "VIdeoListVC", storyBoard: "Home") as! VIdeoListVC
                                    vc.arrAskQuestion = data
                                    vc.imgUpload = self.imgUpload
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                          //  }
                        }else{
                            OperationQueue.main.addOperation {
                                BaseApi.hideActivirtIndicator()
                                self.showToast(message: "Please Enter Correct Phone Number Or Email Id and PIN")
                            }
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
/*
 ["is_image_blur": 0, "notification": <__NSArrayM 0x282e8e5e0>(

 )
 , "matched_count": 20, "user_language_video_heading": Solution Videos in english, "auto_play_initiation": 0, "is_subscribed": 0, "question_image": https://d10lpgp6xz60nq.cloudfront.net/images/upload_761647421_1616825836.png, "question_id": 761647421, "other_language_video_heading": Solution Videos in other languages, "is_blur": <null>, "handwritten": 0, "is_exact_match": 0, "cdn_video_base_url": https://doubtnut.s.llnwi.net/, "platform_tabs": <__NSArrayM 0x282e8eeb0>(
 {
     display = Doubtnut;
     key = doubtnut;
 },
 {
     display = Google;
     key = google;
 },
 {
     display = CyMath;
     key = cymath;
 },
 {
     display = Quora;
     key = quora;
 },
 {
     display = Yahoo;
     key = yahoo;
 },
 {
     display = Youtube;
     key = youtube;
 }
 )
 , "ocr_text": ` Find the value of `(4)/((216)^((-2)/(3)))+(1)/((256)^((-3)/(4)))+(2)/((243)^((-1)/(5))), "auto_play": 0, "matched_questions": <__NSArrayM 0x282e8e280>(
 {
     "_id" = 1408686;
     "_index" = "question_bank_global_index_usa";
     "_score" = "56.485104";
     "_source" =     {
         "bg_color" = "#F2DDD9";
         chapter = "NUMBER SYSTEM";
         "chapter_alias" = "NUMBER SYSTEM";
         class = 9;
         duration = 328;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "Simplify:\n$\\frac{{4}}{{{\\left({216}\\right)}^{{-\\frac{{2}}{{3}}}}}}+\\frac{{1}}{{{\\left({256}\\right)}^{{-\\frac{{3}}{{4}}}}}}+\\frac{{2}}{{{\\left({243}\\right)}^{{-\\frac{{1}}{{5}}}}}}$";
         likes = 1631;
         "ocr_text" = "Simplify:\n`4/((216)^(-2/3))+1/((256)^(-3/4))+2/((243)^(-1/5))`";
         "package_language" = en;
         "render_katex" = 1;
         share = 815;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 4;
         subject = MATHS;
         "video_language" = en;
         views = 70149;
     };
     "_type" = repository;
     "answer_id" = 2681199;
     "answer_video" = "answer-1598723307_26519231.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1598723307_26519231.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 85;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_1408686.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/1408686/english.webp";
     "resource_type" = video;
     "string_diff_text" = "95 - 100% Match";
     "string_diff_text_bg_color" = "#56BD5B";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1598723307_26519231/answer-1598723307_26519231-master-playlist.m3u8";
 },
 {
     "_id" = 217888111;
     "_index" = "question_bank_global_index_usa";
     "_score" = "48.90613";
     "_source" =     {
         "bg_color" = "#DBF2D9";
         chapter = SIMPLIFICATION;
         "chapter_alias" = SIMPLIFICATION;
         class = 12;
         duration = 420;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 1;
         "katex_ocr_text" = "If ${p}={216}^{{{1}/{3}}}+{243}^{{-{2}/{5}}}+{256}^{{-{1}/{4}}}$, then which of the following is an integer? ";
         likes = 13;
         "ocr_text" = "If `p = 216^(1//3) + 243^(-2//5) + 256^(-1//4)`, then which of the following is an integer? ";
         "package_language" = en;
         "render_katex" = 1;
         share = 6;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-54";
         subject = MATHS;
         "video_language" = en;
         views = 995;
     };
     "_type" = repository;
     "answer_id" = 2378003;
     "answer_video" = "answer-1593398580_217888111.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1593398580_217888111.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 45;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_217888111.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/217888111/english.webp";
     "resource_type" = video;
     "string_diff_text" = "90 - 95% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1593398580_217888111/answer-1593398580_217888111-master-playlist.m3u8";
 },
 {
     "_id" = 244152236;
     "_index" = "question_bank_global_index_usa";
     "_score" = "46.605892";
     "_source" =     {
         "bg_color" = "#F2DDD9";
         chapter = "EXPONENTS AND POWERS";
         "chapter_alias" = "EXPONENTS AND POWERS";
         class = 9;
         duration = 240;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "${\\left({1}\\right)}\\frac{{{4}}}{{{\\left({216}\\right)}^{{\\frac{{{2}}}{{{3}}}}}}}+\\frac{{{1}}}{{{\\left({256}\\right)}^{{\\frac{{{3}}}{{{4}}}}}}}+\\frac{{{2}}}{{{\\left({243}\\right)}^{{\\frac{{{1}}}{{{5}}}}}}}{\\left({i}{i}\\right)}{\\left(\\frac{{{64}}}{{{125}}}\\right)}^{{\\frac{{{2}}}{{{3}}}}}+{\\left(\\frac{{{256}}}{{{625}}}\\right)}^{{\\frac{{{1}}}{{{4}}}}}+{\\left(\\frac{{{3}}}{{{7}}}\\right)}^{{{0}}}{\\left({i}{i}{i}\\right)}{\\left(\\frac{{{81}}}{{{16}}}\\right)}^{{\\frac{{{3}}}{{{4}}}}}{\\left({\\left(\\frac{{{25}}}{{{9}}}\\right)}^{{\\frac{{{3}}}{{{2}}}}}\\div{\\left(\\frac{{{5}}}{{{2}}}\\right)}^{{-{3}}}\\right)}{\\left({i}{v}\\right)}\\frac{{{\\left({25}\\right)}^{{\\frac{{{5}}}{{{2}}}}}\\times{\\left({729}\\right)}^{{\\frac{{{1}}}{{{3}}}}}}}{{{\\left({125}\\right)}^{{\\frac{{{2}}}{{{3}}}}}\\times{\\left({27}\\right)}^{{\\frac{{{2}}}{{{3}}}}}\\times{8}^{{\\frac{{{4}}}{{{3}}}}}}}$";
         likes = 41;
         "ocr_text" = "`(1) (4)/((216)^((2)/(3)))+(1)/((256)^((3)/(4)))+(2)/((243)^((1)/(5)))\n (ii) ((64)/(125))^((2)/(3))+((256)/(625))^((1)/(4))+((3)/(7))^(0)\n (iii) ((81)/(16))^((3)/(4))(((25)/(9))^((3)/(2))-:((5)/(2))^(-3))\n (iv) ((25)^((5)/(2))times(729)^((1)/(3)))/((125)^((2)/(3))times(27)^((2)/(3))times8^((4)/(3)))`";
         "package_language" = en;
         "render_katex" = 1;
         share = 4;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-52";
         subject = MATHS;
         "video_language" = en;
         views = 1610;
     };
     "_type" = repository;
     "answer_id" = 2585387;
     "answer_video" = "answer-1597857701_244152236.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1597857701_244152236.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 64;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_244152236.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/244152236/english.webp";
     "resource_type" = video;
     "string_diff_text" = "90 - 95% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1597857701_244152236/answer-1597857701_244152236-master-playlist.m3u8";
 },
 {
     "_id" = 4380425;
     "_index" = "question_bank_global_index_usa";
     "_score" = "41.218647";
     "_source" =     {
         "bg_color" = "#D9DFF2";
         chapter = "SURDS AND INDICES";
         "chapter_alias" = "SURDS AND INDICES";
         class = 14;
         duration = 134;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "The value of $\\frac{{1}}{{{\\left({216}\\right)}^{{-{2}/{3}}}}}+\\frac{{1}}{{{\\left({256}\\right)}^{{-{3}/{4}}}}}+\\frac{{1}}{{{\\left({32}\\right)}^{{-{1}/{5}}}}}$ is\na. ${102}$\nb. ${105}$\nc. ${107}$ \nd. ${109}$";
         likes = 1458;
         "ocr_text" = "The value of `1/((216)^(-2//3))+1/((256)^(-3//4))+1/((32)^(-1//5))` is\na. `102`\nb. `105`\nc. `107` \nd. `109`";
         "package_language" = en;
         "render_katex" = 1;
         share = 162;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 16;
         subject = MATHS;
         "video_language" = en;
         views = 52510;
     };
     "_type" = repository;
     "answer_id" = 171162;
     "answer_video" = "answer-1543512764.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1543512764.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 81;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_4380425.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/4380425/english.webp";
     "resource_type" = video;
     "string_diff_text" = "85 - 90% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1543512764/answer-1543512764-master-playlist.m3u8";
 },
 {
     "_id" = 41916657;
     "_index" = "question_bank_global_index_usa";
     "_score" = "39.763737";
     "_source" =     {
         "bg_color" = "#DBF2D9";
         chapter = "EXPONENTS AND POWERS";
         "chapter_alias" = "EXPONENTS AND POWERS";
         class = 8;
         duration = 182;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 1;
         "katex_ocr_text" = "${4}\\times{\\left({256}\\right)}^{{\\frac{{-{1}}}{{4}}}}\\div{\\left({243}\\right)}^{{\\frac{{1}}{{5}}}}=$";
         likes = 15;
         "ocr_text" = "`4xx(256)^((-1)/4) div (243)^(1/5)=`";
         "package_language" = en;
         "render_katex" = 1;
         share = 2;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 33;
         subject = MATHS;
         "video_language" = en;
         views = 1086;
     };
     "_type" = repository;
     "answer_id" = 812279;
     "answer_video" = "answer-1571747615_41916657.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1571747615_41916657.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 74;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_41916657.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/41916657/english.webp";
     "resource_type" = video;
     "string_diff_text" = "80 - 85% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1571747615_41916657/answer-1571747615_41916657-master-playlist.m3u8";
 },
 {
     "_id" = 446655257;
     "_index" = "question_bank_global_index_usa";
     "_score" = "35.44121";
     "_source" =     {
         "bg_color" = "#F2EED9";
         chapter = "FUNDAMENTALS ";
         "chapter_alias" = "QUESTION BANK";
         class = 14;
         duration = 381;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 0;
         "is_text_answered" = 1;
         likes = 27;
         "ocr_text" = "Find the value <br> `3/2 \" of \" (4/3 div 5/7) + 1/2 div [3 4/5 - {2/5 -(1/3 + 1/2  + bar(1/5 - 1/6))}]`";
         "package_language" = en;
         "render_katex" = 0;
         share = 4;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-89";
         subject = MATHS;
         "video_language" = en;
         views = 351;
     };
     "_type" = repository;
     "answer_id" = 5984516;
     "answer_video" = "answer-1616705347_446655257.mp4";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     html = "";
     "partial_score" = 70;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_446655257.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/446655257/english.webp";
     "resource_type" = video;
     "string_diff_text" = "80 - 85% Match";
     "string_diff_text_bg_color" = "#DAB244";
 },
 {
     "_id" = 24620;
     "_index" = "question_bank_global_index_usa";
     "_score" = "35.357548";
     "_source" =     {
         "bg_color" = "#D9EEF2";
         chapter = "NUMBER SYSTEM";
         "chapter_alias" = "NUMBER SYSTEM";
         class = 9;
         duration = 171;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "  Simplify each of the following:
 \n(i)${\\left({16}\\right)}^{{\\frac{{1}}{{5}}}}\\times{\\left({2}\\right)}^{{\\frac{{1}}{{5}}}}$
 \n (ii) $\\frac{{\\left({243}\\right)}^{{\\frac{{1}}{{4}}}}}{{\\left({3}\\right)}^{{\\frac{{1}}{{4}}}}}$";
         likes = 2645;
         "ocr_text" = "  Simplify each of the following:
 \n(i)`(16)^(1/5)xx(2)^(1/5)`
 \n (ii) `(243)^(1/ 4)/(3)^(1/ 4)`";
         "package_language" = en;
         "render_katex" = 1;
         share = 377;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 4;
         subject = MATHS;
         "video_language" = en;
         views = 31743;
     };
     "_type" = repository;
     "answer_id" = 21110;
     "answer_video" = "answer-1495880307.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1495880307.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 57;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_24620.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/24620/english.webp";
     "resource_type" = video;
     "string_diff_text" = "80 - 85% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1495880307/answer-1495880307-master-playlist.m3u8";
 },
 {
     "_id" = 436828026;
     "_index" = "question_bank_global_index_usa";
     "_score" = "34.93371";
     "_source" =     {
         "bg_color" = "#D9EEF2";
         chapter = "INDICES AND SURDS";
         "chapter_alias" = "SURDS AND INDICES";
         class = 14;
         duration = 131;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 1;
         likes = 17;
         "ocr_text" = "If {(2^(4))^(1//2)}^(?)=256 , find the value of ?.";
         "package_language" = en;
         "render_katex" = 0;
         share = 8;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-89";
         subject = MATHS;
         "video_language" = en;
         views = 1365;
     };
     "_type" = repository;
     "answer_id" = 3343206;
     "answer_video" = "answer-1603688361_436828026.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1603688361_436828026.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 53;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_436828026.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/436828026/english.webp";
     "resource_type" = video;
     "string_diff_text" = "75 - 80% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1603688361_436828026/answer-1603688361_436828026-master-playlist.m3u8";
 },
 {
     "_id" = 1408712;
     "_index" = "question_bank_global_index_usa";
     "_score" = "34.754753";
     "_source" =     {
         "bg_color" = "#EBD9F2";
         chapter = "NUMBER SYSTEM";
         "chapter_alias" = "NUMBER SYSTEM";
         class = 9;
         duration = 191;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "Simplify:\n${\\left({i}\\right)}\\ {\\left({0}.{001}\\right)}^{{\\frac{{1}}{{3}}}}$\n\n   ${\\left({i}{i}\\right)}\\ \\frac{{{\\left({25}\\right)}^{{\\frac{{3}}{{2}}}}\\ \\times\\ {\\left({243}\\right)}^{{\\frac{{3}}{{5}}}}}}{{{\\left({16}\\right)}^{{\\frac{{5}}{{4}}}}\\ \\times\\ {\\left({8}\\right)}^{{\\frac{{4}}{{3}}}}}}$";
         likes = 1818;
         "ocr_text" = "Simplify:\n`(i)\\ (0. 001)^(1/3)`\n\n   `(ii)\\ ((25)^(3/2)\\ xx\\ (243)^(3/5))/((16)^(5/4)\\ xx\\ (8)^(4/3))`";
         "package_language" = en;
         "render_katex" = 1;
         share = 303;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 4;
         subject = MATHS;
         "video_language" = en;
         views = 125451;
     };
     "_type" = repository;
     "answer_id" = 106513;
     "answer_video" = "answer-1528955691.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1528955691.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 53;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_1408712.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/1408712/english.webp";
     "resource_type" = video;
     "string_diff_text" = "75 - 80% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1528955691/answer-1528955691-master-playlist.m3u8";
 },
 {
     "_id" = 3639355;
     "_index" = "question_bank_global_index_usa";
     "_score" = "34.60334";
     "_source" =     {
         "bg_color" = "#D9EEF2";
         chapter = "NUMBER SYSTEM";
         "chapter_alias" = "NUMBER SYSTEM";
         class = 14;
         duration = 81;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "Find the
 \n  value of ${4}-\\frac{{5}}{{{1}+\\frac{{1}}{{{3}+\\frac{{1}}{{{2}+\\frac{{1}}{{4}}}}}}}}$";
         likes = 198;
         "ocr_text" = "Find the
 \n  value of `4-5/(1+1/(3+1/(2+1/4)))`";
         "package_language" = en;
         "render_katex" = 1;
         share = 39;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 16;
         subject = MATHS;
         "video_language" = en;
         views = 12114;
     };
     "_type" = repository;
     "answer_id" = 154092;
     "answer_video" = "answer-1540565545.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1540565545.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 79;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_3639355.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/3639355/english.webp";
     "resource_type" = video;
     "string_diff_text" = "75 - 80% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1540565545/answer-1540565545-master-playlist.m3u8";
 },
 {
     "_id" = 4380427;
     "_index" = "question_bank_global_index_usa";
     "_score" = "34.435886";
     "_source" =     {
         "bg_color" = "#DBF2D9";
         chapter = "SURDS AND INDICES";
         "chapter_alias" = "SURDS AND INDICES";
         class = 14;
         duration = 83;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "${\\left(\\frac{{1}}{{216}}\\right)}^{{-{2}/{3}}}\\div{\\left(\\frac{{1}}{{27}}\\right)}^{{-{4}/{3}}}=?$\na. $\\frac{{3}}{{4}}$\nb. $\\frac{{2}}{{3}}$\nc. $\\frac{{4}}{{9}}$\nd. $\\frac{{1}}{{8}}$";
         likes = 723;
         "ocr_text" = "`(1/216)^(-2//3)-:(1/27)^(-4//3)=?`\na. `3/4`\nb. `2/3`\nc. `4/9`\nd. `1/8`";
         "package_language" = en;
         "render_katex" = 1;
         share = 241;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 16;
         subject = MATHS;
         "video_language" = en;
         views = 51352;
     };
     "_type" = repository;
     "answer_id" = 171516;
     "answer_video" = "answer-1543570381.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1543570381.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 65;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_4380427.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/4380427/english.webp";
     "resource_type" = video;
     "string_diff_text" = "75 - 80% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1543570381/answer-1543570381-master-playlist.m3u8";
 },
 {
     "_id" = 508114186;
     "_index" = "question_bank_global_index_usa";
     "_score" = "34.317184";
     "_source" =     {
         "bg_color" = "#D9EEF2";
         chapter = "BASIC ALGEBRA";
         "chapter_alias" = "BASIC ALGEBRA";
         class = 11;
         duration = 86;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         likes = 162;
         "ocr_text" = "Evaluate `[((256)^(-1/2))^(-1/4)]^(3)`";
         "package_language" = en;
         "render_katex" = 0;
         share = 20;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-79";
         subject = MATHS;
         "video_language" = ta;
         views = 1629;
     };
     "_type" = repository;
     "answer_id" = 4413358;
     "answer_video" = "answer-1608984237_508114186.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1608984237_508114186.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 64;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_508114186.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/508114186/english.webp";
     "resource_type" = video;
     "string_diff_text" = "75 - 80% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1608984237_508114186/answer-1608984237_508114186-master-playlist.m3u8";
 },
 {
     "_id" = 402451235;
     "_index" = "question_bank_global_index_usa";
     "_score" = "34.243168";
     "_source" =     {
         "bg_color" = "#F2DDD9";
         chapter = "SOLVED PAPER 10";
         "chapter_alias" = "QUESTION BANK";
         class = 11;
         duration = 194;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         likes = 156999;
         "ocr_text" = "Evaluate  `[((256)^(-1/2))^(-1/4)]^3`";
         "package_language" = en;
         "render_katex" = 0;
         share = 15699;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-79";
         subject = MATHS;
         "video_language" = ta;
         views = 2825983;
     };
     "_type" = repository;
     "answer_id" = 4061533;
     "answer_video" = "answer-1607614588_402451235.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1607614588_402451235.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 64;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_402451235.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/402451235/english.webp";
     "resource_type" = video;
     "string_diff_text" = "70 - 75% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1607614588_402451235/answer-1607614588_402451235-master-playlist.m3u8";
 },
 {
     "_id" = 1531748;
     "_index" = "question_bank_global_index_usa";
     "_score" = "33.956863";
     "_source" =     {
         "bg_color" = "#EBD9F2";
         chapter = "EXPONENTS AND POWER";
         "chapter_alias" = "EXPONENTS AND POWERS";
         class = 7;
         duration = 154;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "\n\n\n\n${\\left({1}+{3}+{5}+{7}+{9}+{11}\\right)}^{{\\frac{{3}}{{2}}}}$\n\n\n\n\U00a0\n\n=\n(a)36\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\n  (b) 216\n(c)256\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0 \U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0(d) none of these";
         likes = 353;
         "ocr_text" = "\n\n\n\n`(\n\n1+3+5+7+9+11\n)^\n\n\n(3/2)`\n\n\n\n\U00a0\n\n=\n(a)36\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\n  (b) 216\n(c)256\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0 \U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0\U00a0(d) none of these";
         "package_language" = en;
         "render_katex" = 1;
         share = 35;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 4;
         subject = MATHS;
         "video_language" = en;
         views = 8827;
     };
     "_type" = repository;
     "answer_id" = 477929;
     "answer_video" = "answer-1563014514_1531748.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1563014514_1531748.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 40;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_1531748.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/1531748/english.webp";
     "resource_type" = video;
     "string_diff_text" = "70 - 75% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1563014514_1531748/answer-1563014514_1531748-master-playlist.m3u8";
 },
 {
     "_id" = 446655271;
     "_index" = "question_bank_global_index_usa";
     "_score" = "33.74984";
     "_source" =     {
         "bg_color" = "#EBD9F2";
         chapter = "FUNDAMENTALS ";
         "chapter_alias" = "QUESTION BANK";
         class = 14;
         duration = 214;
         "exact_match" = 0;

         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 1;
         likes = 20;
         "ocr_text" = "Calculate the value of 4/(2 1/3) + 3/(1 3/4) - 5/(3 1/2) .";
         "package_language" = en;
         "render_katex" = 0;
         share = 3;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-89";
         subject = MATHS;
         "video_language" = en;
         views = 740;
     };
     "_type" = repository;
     "answer_id" = 3552488;
     "answer_video" = "answer-1605103029_446655271.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1605103029_446655271.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 72;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_446655271.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/446655271/english.webp";
     "resource_type" = video;
     "string_diff_text" = "70 - 75% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1605103029_446655271/answer-1605103029_446655271-master-playlist.m3u8";
 },
 {
     "_id" = 446654492;
     "_index" = "question_bank_global_index_usa";
     "_score" = "33.650394";
     "_source" =     {
         "bg_color" = "#D9EEF2";
         chapter = "FUNDAMENTALS ";
         "chapter_alias" = "QUESTION BANK";
         class = 14;
         duration = 384;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 0;
         "is_text_answered" = 1;
         likes = 259262;
         "ocr_text" = "Solve the followings : <br> The value of the expression <br> `((0.3)^(1//3).(1/27)^(1//4) . (9)^(1//6).(0.81)^(2//3))/((0.9)^(2//3) . (3)^(-1//2) . (1/3)^(-2). (243)^(-1//4))` is  : ";
         "package_language" = en;
         "render_katex" = 0;
         share = 28806;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-89";
         subject = MATHS;
         "video_language" = en;
         views = 28259650;
     };
     "_type" = repository;
     "answer_id" = 5431719;
     "answer_video" = "answer-1613969827_446654492.mp4";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     html = "";
     "partial_score" = 62;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_446654492.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/446654492/english.webp";
     "resource_type" = video;
     "string_diff_text" = "65 - 70% Match";
     "string_diff_text_bg_color" = "#DAB244";
 },
 {
     "_id" = 40380039;
     "_index" = "question_bank_global_index_usa";
     "_score" = "33.42308";
     "_source" =     {
         "bg_color" = "#F2DDD9";
         chapter = "INDICES ";
         "chapter_alias" = "EXPONENTS AND POWER";
         class = 7;
         duration = 129;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 1;
         "katex_ocr_text" = "If ${\\left({2}{x}^{{2}}-{y}^{{2}}\\right)}^{{4}}={256}{\\quad\\text{and}\\quad}{\\left({x}^{{2}}+{y}^{{2}}\\right)}^{{5}}={243}$, then find ${x}^{{4}}-{y}^{{4}}$ <br> The following steps are involved in solving the above problem. Arragne then in sequential order. <br> (A) ${\\left({x}^{{2}}-{y}^{{2}}\\right)}^{{4}}={256}={4}^{{4}}{\\quad\\text{and}\\quad}{\\left({x}^{{2}}+{y}^{{2}}\\right)}^{{5}}={3}^{{5}}$ <br> (B) ${x}^{{4}}-{y}^{{4}}={12}$ <br> (C) ${\\left({x}^{{2}}-{y}^{{2}}\\right)}{\\left({x}^{{2}}+{y}^{{2}}\\right)}={4}\\times{3}$ <br>(D) ${x}^{{2}}-{y}^{{2}}={4}{\\quad\\text{and}\\quad}{x}^{{2}}+{y}^{{2}}={3}$ ";
         likes = 114;
         "ocr_text" = "If `(2x^2-y^2)^4=256 and (x^2+y^2)^5=243`, then find `x^4-y^4` <br> The following steps are involved in solving the above problem. Arragne then in sequential order. <br> (A) `(x^2-y^2)^4=256=4^4 and (x^2+y^2)^5=3^5` <br> (B) `x^4-y^4=12` <br> (C) `(x^2-y^2)(x^2+y^2)=4xx3` <br>(D) `x^2-y^2=4 and x^2+y^2=3` ";
         "package_language" = en;
         "render_katex" = 1;
         share = 22;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 33;
         subject = MATHS;
         "video_language" = en;
         views = 1710;
     };
     "_type" = repository;
     "answer_id" = 3000560;
     "answer_video" = "answer-1601120294_40380039.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1601120294_40380039.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 51;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_40380039.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/40380039/english.webp";
     "resource_type" = video;
     "string_diff_text" = "65 - 70% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1601120294_40380039/answer-1601120294_40380039-master-playlist.m3u8";
 },
 {
     "_id" = 98160173;
     "_index" = "question_bank_global_index_usa";
     "_score" = "32.8289";
     "_source" =     {
         "bg_color" = "#D9EEF2";
         chapter = "NUMBER SYSTEMS";
         "chapter_alias" = "NUMBER SYSTEM";
         class = 9;
         duration = 315;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 0;
         "katex_ocr_text" = "Prove that . <br>  (i) ${\\left[{8}^{{-\\frac{{{2}}}{{{3}}}}}\\times{2}^{{\\frac{{{1}}}{{{2}}}}}\\times{25}^{{-\\frac{{{5}}}{{{4}}}}}\\right]}\\div{\\left[{32}^{{-\\frac{{{2}}}{{{5}}}}}\\times{125}^{{-\\frac{{{5}}}{{{6}}}}}\\right]}=\\sqrt{{{2}}}$  <br>  (ii) ${\\left(\\frac{{{64}}}{{{125}}}\\right)}^{{-\\frac{{{2}}}{{{3}}}}}=\\frac{{{1}}}{{{\\left(\\frac{{{256}}}{{{625}}}\\right)}^{{\\frac{{{1}}}{{{4}}}}}}}+\\frac{{\\sqrt{{{25}}}}}{{{\\sqrt[{3}]{{{64}}}}}}=\\frac{{{65}}}{{{16}}}$ <br> (iii) ${\\left[{7}{\\left\\lbrace{\\left({81}\\right)}^{{\\frac{{{1}}}{{{4}}}}}+{\\left({256}\\right)}^{{\\frac{{{1}}}{{{4}}}}}\\right\\rbrace}^{{\\frac{{{1}}}{{{4}}}}}\\right]}^{{{4}}}={16807}$ .";
         likes = 11;
         "ocr_text" = "Prove that . <br>  (i) `[8^(-(2)/(3)) xx 2^((1)/(2))xx 25^(-(5)/(4))] div[32^(-(2)/(5)) xx 125 ^(-(5)/(6)) ] = sqrt(2)`  <br>  (ii) `((64)/(125))^(-(2)/(3)) = (1)/(((256)/(625))^((1)/(4)))+ (sqrt(25))/(root3(64)) = (65)/(16)` <br> (iii) `[7{(81)^((1)/(4)) +(256)^((1)/(4))}^((1)/(4))]^(4) = 16807` .";
         "package_language" = en;
         "render_katex" = 1;
         share = 1;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = 16;
         subject = MATHS;
         "video_language" = en;
         views = 565;
     };
     "_type" = repository;
     "answer_id" = 1382432;
     "answer_video" = "answer-1581509440_98160173.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1581509440_98160173.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 51;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_98160173.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/98160173/english.webp";
     "resource_type" = video;
     "string_diff_text" = "65 - 70% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1581509440_98160173/answer-1581509440_98160173-master-playlist.m3u8";
 },
 {
     "_id" = 446659363;
     "_index" = "question_bank_global_index_usa";
     "_score" = "32.71054";
     "_source" =     {
         "bg_color" = "#F2DDD9";
         chapter = "SEQUENCE, SERIES & PROGRESSIONS";
         "chapter_alias" = "QUESTION BANK";
         class = 14;
         duration = 0;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 0;
         "is_text_answered" = 1;
         likes = 10;
         "ocr_text" = "Find the sum of 1+ 2/3 + 4/9 + 6/(27) + 8/(81) + (10)/(243) + \U2026 oo :";
         "package_language" = en;
         "render_katex" = 0;
         share = 1;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-89";
         subject = MATHS;
         "video_language" = en;
         views = 1040;
     };
     "_type" = repository;
     "answer_id" = 5112663;
     "answer_video" = text;
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "partial_score" = 67;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_446659363.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/446659363/english.webp";
     "resource_type" = text;
     "string_diff_text" = "60 - 65% Match";
     "string_diff_text_bg_color" = "#DAB244";
 },
 {
     "_id" = 127292894;
     "_index" = "question_bank_global_index_usa";
     "_score" = "32.575905";
     "_source" =     {
         "bg_color" = "#D9EEF2";
         chapter = "SEQUENCES AND SERIES";
         "chapter_alias" = "SEQUENCES AND SERIES";
         class = 12;
         duration = 167;
         "exact_match" = 0;
         isLiked = 0;
         "is_answered" = 1;
         "is_text_answered" = 1;
         "katex_ocr_text" = "If ${\\left({1}-{p}\\right)}{\\left({1}+{3}{x}+{9}{x}^{{{2}}}+{27}{x}^{{{3}}}+{81}{x}^{{{4}}}+{243}{x}^{{{5}}}\\right)}={\\left({1}-{p}^{{{6}}}\\right)}{\\left({p}\\ne{1}\\right)}$, then the value of $\\frac{{{p}}}{{{x}}}$ will be -";
         likes = 16;
         "ocr_text" = "If `(1-p) (1+3x + 9x^(2) + 27x^(3) + 81 x^(4) + 243 x^(5)) = (1-p^(6)) (p != 1)`, then the value of `(p)/(x)` will be -";
         "package_language" = en;
         "render_katex" = 1;
         share = 3;
         "share_message" = "Improve your SAT or ACT Score with Math, Science and solved Practice Tests Video Solutions only on Doubtnut!!";
         "student_id" = "-30";
         subject = MATHS;
         "video_language" = bn;
         views = 625;
     };
     "_type" = repository;
     "answer_id" = 1906819;
     "answer_video" = "answer-1587466575_127292894.mp4";
     "cdn_base_url" = "https://doubtnut.s.llnwi.net/";
     chapter = "<null>";
     class = "<null>";
     "difficulty_level" = "<null>";
     "fallback_url" = "https://doubtnut.s.llnwi.net/answer-1587466575_127292894.mp4";
     "hls_timeout" = 0;
     html = "";
     "partial_score" = 49;
     "question_thumbnail" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail/en_127292894.png";
     "question_thumbnail_localized" = "https://doubtnut-static.s.llnwi.net/static/q-thumbnail-localized/127292894/english.webp";
     "resource_type" = video;
     "string_diff_text" = "60 - 65% Match";
     "string_diff_text_bg_color" = "#DAB244";
     "video_url" = "https://d1zcq8u9izvjk5.cloudfront.net/HLS/answer-1587466575_127292894/answer-1587466575_127292894-master-playlist.m3u8";
 }
 )
 , "is_only_equation": 0, "more_user_language_videos_text": show more english videos, "auto_play_duration": 5000, "feedback": {
     "bg_color" = "#e0eaff";
     "feedback_text" = "Happy with the Solutions";
     "is_show" = 0;
 }, "is_image_handwritten": 0, "tab": <__NSArrayM 0x282e8e580>(

 )
 ]
 */
