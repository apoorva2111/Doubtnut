//
//  CommentsVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 29/05/21.
//

import UIKit

class CommentsVC: UIViewController {
    @IBOutlet weak var tblComment: UITableView!
    
    var quesID = ""
    var arrComment = [NSDictionary]()
    var arrReplyComment = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblComment.register(UINib.init(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell")
        callWebserviceForGetComment()
    }
    

    
    func callWebserviceForGetComment() {
        BaseApi.showActivityIndicator(icon: nil, text: "")
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v3/comment/get-list-by-entity/answered/\(quesID)?page=1")! as URL)
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
                                        if self.arrComment.count>0{
                                            self.arrComment.removeAll()
                                        }
                                        for obj in data {
                                            self.arrComment.append(obj as! NSMutableDictionary)
                                        }
                                        self.tblComment.reloadData()
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
    
    func callWebserviceForLikeDislikeComment(commentID:String, isLike:Int) {
        
        
        BaseApi.showActivityIndicator(icon: nil, text: "")
       
        let parameters = ["comment_id": commentID,
                          "is_like": isLike ] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v2/comment/like")! //change the url
        
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
                        UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param), URL:- https://api.doubtnut.app/v2/comment/like", message: "Response: \(jsonString)     version_code:- 845", buttons: ["OK","DISSMISS"], viewobj: self) { (clickButton) in
                            
                            if clickButton == "OK" {
                                BaseApi.hideActivirtIndicator()
                                
                                if let meta = json["meta"] as? [String:AnyObject]{
                                    let code = meta["code"] as! Int
                                    BaseApi.hideActivirtIndicator()
                                    
                                    if code == 200 {
                                        BaseApi.hideActivirtIndicator()
                                        self.callWebserviceForGetComment()
                                        
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
    
    func callWebserviceForGetReplyComment(commentId : String) {
        BaseApi.showActivityIndicator(icon: nil, text: "")
//        "https://api.doubtnut.app/v3/comment/get-list-by-entity/answered/\(quesID)?page=1"
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v3/comment/get-list-by-entity/comment/\(commentId)?page=1")! as URL)
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
                                        if self.arrReplyComment.count>0{
                                            self.arrReplyComment.removeAll()
                                        }
                                        for obj in data {
                                            self.arrReplyComment.append(obj as! NSMutableDictionary)
                                        }
                                        self.tblComment.reloadData()
                                    }else{
                                        BaseApi.hideActivirtIndicator()
                                    }
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
}
extension CommentsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblComment.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as! CommentTVCell
        cell.setCell(dict: arrComment[indexPath.row], arrReply: arrReplyComment)
        cell.btnLikeOutlet.tag = indexPath.row
        cell.btnLikeOutlet.addTarget(self, action: #selector(btnCommentLikeAction(_:)), for: .touchUpInside)
        cell.btnReplyOutlet.addTarget(self, action: #selector(btnCommentReplyCation), for: .touchUpInside)
        cell.btnDeleteCommentOutlet.addTarget(self, action: #selector(btnDeleteCommnetAction), for: .touchUpInside)
        cell.btnReplyOutlet.tag = indexPath.row
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func btnCommentLikeAction(_ sender: UIButton){
        let obj = arrComment[sender.tag]
        print(obj)
        if let commentId = obj["_id"] as? String{
            if let liked = obj["is_liked"] as? Int{
                if liked == 0{
                    callWebserviceForLikeDislikeComment(commentID: commentId, isLike: 1)
                }else{
                    callWebserviceForLikeDislikeComment(commentID: commentId, isLike: 0)
                }
            }
        }
    }
    
    @objc func btnCommentReplyCation(_ sender: UIButton){
        let obj = arrComment[sender.tag]
        arrComment.removeAll()
        arrComment.append(obj)
        if let commentId = obj["_id"] as? String{
            callWebserviceForGetReplyComment(commentId: commentId)
        }
      //
    }
    
    @objc func btnDeleteCommnetAction(_ sender: UIButton){
        let point = tblComment.convert(sender.center, from: sender.superview!)

                if let wantedIndexPath = tblComment.indexPathForRow(at: point) {
                    let cell = tblComment.cellForRow(at: wantedIndexPath) as! CommentTVCell
                    if sender.isSelected{
                        sender.isSelected = false
                        cell.viewRemoveMsg.isHidden = true

                    }else{
                        sender.isSelected = true
                        cell.viewRemoveMsg.isHidden = false
                    }

                }
    }
    func sendComment(){
        do {
            let decoded  = userDef.object(forKey: "dataDict") as! Data
            if let dataD = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? NSDictionary{
                
                let accId_selected = dataD["_id"] as! Int
                let insID = dataD["insid"] as! Int
                let userid = dataD["userid"] as! Int
                let formattedArray = (self.arrDes.map{String($0)}).joined(separator: ",")
                
                let dict1 = ["description" : formattedArray]
                let dict2 = ["account_id" : accId_selected]
                let dict3 = ["action_type": isUpload]
                let dict4 = ["insid": insID]
                let dict5 = ["userid": userid]
                
                let arrParam = NSMutableArray()
                arrParam.insert(dict1, at: 0)
                arrParam.insert(dict2, at: 1)
                arrParam.insert(dict3, at: 2)
                arrParam.insert(dict4, at: 3)
                arrParam.insert(dict5, at: 4)
                
                print(arrParam)

                let authToken = userDef.value(forKey: "authToken") as! String
                let headers: HTTPHeaders = [
                    "Authorization": authToken,
                    "Content-type": "multipart/form-data"
                ]
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    // import image to request
                    for imageData in self.arrimages {
                        multipartFormData.append(imageData, withName: "file[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    }
                    for i in 0..<arrParam.count{
                        let parameters  = arrParam[i] as! [String:Any]
                        for (key, value) in parameters {
                            let newVal = "\(value)"
                            multipartFormData.append((newVal).data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }
                }, to: Constant.file_url,method:HTTPMethod.post,
                   headers:headers,
                   encodingCompletion: { encodingResult in
                    DispatchQueue.main.async {
                        
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                
                                Globalfunc.hideLoaderView(view: self.view)
                                print(response)
                                if let dict = response.result.value as? NSDictionary{
                                    let msg = dict["msg"] as! String
                                    let alertController = UIAlertController(title: Constant.AppName, message: msg, preferredStyle: .alert)
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                    alertController.addAction(OKAction)
                                    self.present(alertController, animated: true, completion:nil)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                })
            }
        }
        catch {
        }
    }
}
