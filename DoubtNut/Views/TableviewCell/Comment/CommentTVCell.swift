//
//  CommentTVCell.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 29/05/21.
//

import UIKit
import SDWebImage
class CommentTVCell: UITableViewCell {
    @IBOutlet weak var imgProfile: RCustomImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgDescription: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var btnReplyOutlet: UIButton!
    @IBOutlet weak var btnReplyCountOutlet: UIButton!
    @IBOutlet weak var btnReplyHeightOutlet: NSLayoutConstraint!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnDeleteCommentOutlet: UIButton!
    @IBOutlet weak var tblReply: UITableView!
    @IBOutlet weak var tblReplyHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewRemoveMsg: RCustomView!
    @IBOutlet weak var btnRemoveMsgOutlet: UIButton!
    var arrReplyComment = [NSDictionary]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(dict:NSDictionary, arrReply:[NSDictionary]) {
        print(dict)
        
        arrReplyComment = arrReply
        if arrReply.count>0{
            tblReply.register(UINib.init(nibName: "ReplyCommentTVCell", bundle: nil), forCellReuseIdentifier: "ReplyCommentTVCell")
            tblReplyHeightConstraint.constant =  CGFloat(170 * arrReplyComment.count)
            tblReply.delegate = self
            tblReply.dataSource = self
            tblReply.reloadData()
        }
        if let url = dict["student_avatar"] as? String{
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgProfile.sd_setImage(with: URL.init(string: url), completed: nil)
        }
        if let userName = dict["student_username"] as? String{
            lblUserName.text = userName
        }
        
        if let message = dict["original_message"] as? String{
            lblDescription.text = message
        }
   //
        if let likedBy = dict["liked_by"] as? NSArray {
            print(likedBy.count)
            if likedBy.count>0{
                let likCount = String(likedBy.count)
                lblLikeCount.text = likCount
            }else{
                lblLikeCount.text = ""
            }
       //
        }
        if let img = dict["image"] as? String{
            print(img)
            if img == ""{
                imgDescription.isHidden = true
            }else{
                imgDescription.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgDescription.contentMode = .scaleToFill
                imgDescription.sd_setImage(with: URL.init(string: img), completed: nil)
            }
        }
        
        if let liked = dict["is_liked"] as? Int{
            if liked == 0{
                btnLikeOutlet.setTitle("Like", for: .normal)
            }else{
                btnLikeOutlet.setTitle("Unlike", for: .normal)
            }
        }
        
        if let reply = dict["replies_count"] as? Int{
            if reply > 0 {
                let replyCount =  String(reply) + " replies"
                btnReplyCountOutlet.setTitle(replyCount, for: .normal)
                btnReplyHeightOutlet.constant = 30
                btnReplyCountOutlet.isHidden = false
            }else{
                btnReplyHeightOutlet.constant = 0
                btnReplyCountOutlet.isHidden = true
            }
        }
        
        if let createAt = dict["createdAt"] as? String{
            let startDate = createAt.components(separatedBy: "T")
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let start = dateFormatter.date(from: startDate[0])!
            let diff1 = start.daysBetween(date: date) // 365
            lblDate.text = String(diff1) + " " + "days ago"
        }

    
    }
}

//MARK :- UITableview Delegate Datasource
extension CommentTVCell : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReplyComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblReply.dequeueReusableCell(withIdentifier: "ReplyCommentTVCell", for: indexPath) as! ReplyCommentTVCell
        cell.setCell(dict: arrReplyComment[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

//    
//    
}
