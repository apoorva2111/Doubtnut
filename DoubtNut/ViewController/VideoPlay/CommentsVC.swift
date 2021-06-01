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
}
extension CommentsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblComment.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as! CommentTVCell
        cell.setCell(dict: arrComment[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

/*
 ["data": <__NSArrayM 0x283f92fa0>(
 CommentTVCell,
 {
     "__v" = 0;
     "_id" = 60b14e3927944f06a6072cc0;
     audio = "";
     createdAt = "2021-05-29T01:40:33.173Z";
     "entity_id" = 147177403;
     "entity_type" = answered;
     image = "";
     "is_deleted" = 0;
     "is_liked" = 0;
     "is_profane" = 0;
     "liked_by" =     (
     );
     message = test11;
     "original_message" = test11;
     "parent_id" = "<null>";
     "replies_count" = 0;
     "reported_by" =     (
     );
     "resource_url" = "";
     "student_avatar" = "https://d10lpgp6xz60nq.cloudfront.net/images/upload_76944998_1622191912.png";
     "student_id" = 76944998;
     "student_username" = "shivam ";
     type = "top_doubt_answer_text_image";
     updatedAt = "2021-05-29T01:40:33.173Z";
 },
 {
     "__v" = 0;
     "_id" = 60b143051bd14905e7559f5d;
     audio = "";
     createdAt = "2021-05-29T00:52:45.728Z";
     "entity_id" = 147177403;
     "entity_type" = answered;
     image = "";
     "is_deleted" = 0;
     "is_liked" = 0;
     "is_profane" = 0;
     "liked_by" =     (
     );
     message = test;
     "original_message" = test;
     "parent_id" = "<null>";
     "replies_count" = 0;
     "reported_by" =     (
     );
     "resource_url" = "";
     "student_avatar" = "https://d10lpgp6xz60nq.cloudfront.net/images/upload_76944998_1622191912.png";
     "student_id" = 76944998;
     "student_username" = "shivam ";
     type = "top_doubt_answer_text_image";
     updatedAt = "2021-05-29T00:52:45.728Z";
 }
 )
 , "meta": {
     code = 200;
     message = "SUCCESS!";
     success = 1;
 }]
 */
