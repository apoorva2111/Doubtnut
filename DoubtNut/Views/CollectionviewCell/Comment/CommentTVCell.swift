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
            imgProfile.contentMode = .scaleToFill
            imgProfile.sd_setImage(with: URL.init(string: url), completed: nil)
        }
        if let userName = dict["student_username"] as? String{
            lblUserName.text = userName
        }
        
        if let message = dict["original_message"] as? String{
            lblDescription.text = message
        }
        
        if let img = dict["image"] as? String{
            print(img)
        }
        
        if let liked = dict["is_liked"] as? Int{
            if liked == 0{
                btnLikeOutlet.setTitle("Like", for: .normal)
            }else{
                btnLikeOutlet.setTitle("Unlike", for: .normal)
            }
        }
        
        if let reply = dict["replies_count"] as? Int{
            btnReplyOutlet.setTitle(String(reply), for: .normal)
        }
        
    }
}
/*
 {
     "__v" = 0;
     "_id" = 60b62f95c1b959094769929d;
     audio = "";
     createdAt = "2021-06-01T18:31:09.970Z";
     "entity_id" = 147177403;
     "entity_type" = answered;
     image = "";
     "is_deleted" = 0;
     "is_liked" = 0;
     "is_profane" = 0;
     "liked_by" =     (
     );
     message = test1demo;
     "original_message" = test1demo;
     "parent_id" = "<null>";
     "replies_count" = 0;
     "reported_by" =     (
     );
     "resource_url" = "";
     "student_avatar" = "https://d10lpgp6xz60nq.cloudfront.net/images/upload_76944998_1622191912.png";
     "student_id" = 76944998;
     "student_username" = "shivam ";
     type = "top_doubt_answer_text_image";
     updatedAt = "2021-06-01T18:31:09.970Z";
 }
 */
