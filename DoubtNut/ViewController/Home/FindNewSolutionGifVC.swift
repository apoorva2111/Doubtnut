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
    var isFromSearch = false
    
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
    
    func callawebServiewForGenerateUrl(imagevw : UIImage) {
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let Udid = UIDevice.current.identifierForVendor?.uuidString

        print(Udid!)
        let parameters :[String : Any] = ["class":12,
                         "subject":"physics",
                         "chapter":"magnetism",
                         "doubt":"maths",
                         "udid":Udid!,
                         "locale":"en",
                         "content_type":"image/png",
                         "file_ext":".png"]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v1/question/generate-question-image-upload-url")! //change the url

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
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("756", forHTTPHeaderField: "version_code")
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
                    let jsonString = BaseApi.showParam(json: json)
                    UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.app/v1/question/generate-question-image-upload-url", message: "Response: \(jsonString)     version_code:- 756", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK" {
                            OperationQueue.main.addOperation {
                                print(json)
                                BaseApi.hideActivirtIndicator()
                                if let meta = json["meta"] as? [String:AnyObject]{
                                    let code = meta["code"] as! Int
                                    if code == 200 {
                                        if let data = json["data"] as? [String:AnyObject]{
                                            print(data)
                                            let strUrl = data["url"] as? String
                                            let strfileName = data["file_name"] as? String
                                            let question_id = data["question_id"] as? Int
                                            let vc = FlowController().instantiateViewController(identifier: "FindNewSolutionGifVC", storyBoard: "Home") as! FindNewSolutionGifVC
                                            vc.imgUpload = imagevw
                                            vc.imgUploadURL = strUrl ?? ""
                                            vc.file_name = strfileName ?? ""
                                            vc.question_id = question_id ?? 0
                                            self.navigationController?.pushViewController(vc, animated: true)
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

                    /**/
                    // handle json...
                }
            } catch let error {
                OperationQueue.main.addOperation {

                self.showToast(message: "Something Went Wrong")

                BaseApi.hideActivirtIndicator()

                print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
    func upload(image: UIImage, urlString: String, mimeType: String, completion: @escaping (Bool, Error?) -> Void) {
        let data = image.jpegData(compressionQuality: 0.9)!
        upload(data: data, urlString: urlString, mimeType: mimeType, completion: completion)
    }
    
    func callWebserviceForAskQues() {
        
//question_text
        let parameters =
            ["question_image":"image_url",
                          "uploaded_image_name":file_name,
                          "question":"IOS",
                          "limit":"20",
                          "uploaded_image_question_id":question_id] as [String : Any]
        
        //create the url with URL
        print(parameters)
        let url = URL(string: "https://api.doubtnut.com/v10/questions/ask")! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request/body
        } catch let error {
            print(error.localizedDescription)
        }
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Njk5NTkzNTIsImlhdCI6MTYyMDY0MjI5MCwiZXhwIjoxNjgzNzE0MjkwfQ.oSDqsry8VS6Q0dXcasv5sqqgZ02rTCwvtAaYcy5I7CI", forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("844", forHTTPHeaderField: "version_code")

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
                    UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param),  URL:- https://api.doubtnut.com/v10/questions/ask", message: "Response: \(jsonString)     version_code:- 884", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK"{
                            
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
                        }else{
                            BaseApi.hideActivirtIndicator()

                        }
                    }
            
                    // handle json..
                        
                }
            } catch let error {
                OperationQueue.main.addOperation {
                    BaseApi.hideActivirtIndicator()
                }
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
  
}

