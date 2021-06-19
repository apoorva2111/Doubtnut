//
//  ReplyCommentTVCell.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 12/06/21.
//

import UIKit
import SDWebImage
class ReplyCommentTVCell: UITableViewCell {
    @IBOutlet weak var imgProfile: RCustomImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgDescription: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnDeleteCommentOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(dict:NSDictionary) {
        print(dict)
        
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
/*{
 "__v" = 0;
 "_id" = 60b62f6ec1b959094769929c;
 audio = "";
 createdAt = "2021-06-01T18:30:30.758Z";
 "entity_id" = 60b151ab27944f06a6072cc1;
 "entity_type" = comment;
 image = "";
 "is_deleted" = 0;
 "is_liked" = 0;
 "is_profane" = 0;
 "like_count" = 0;
 "liked_by" =     (
 );
 message = ttt;
 "original_message" = ttt;
 "parent_id" = 147177403;
 "replies_count" = 0;
 "reported_by" =     (
 );
 "resource_url" = "";
 "student_avatar" = "https://d10lpgp6xz60nq.cloudfront.net/images/upload_76944998_1622191912.png";
 "student_id" = 76944998;
 "student_username" = "shivam ";
 type = "top_doubt_answer_text_image";
 updatedAt = "2021-06-01T18:30:30.758Z";
}*/
