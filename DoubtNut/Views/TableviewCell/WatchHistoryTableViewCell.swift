//
//  WatchHistoryTableViewCell.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 13/03/21.
//

import UIKit

class WatchHistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var menuRefBtn: UIButton!
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var bottomRightLabel: UILabel!
        
    @IBOutlet weak var playBtnRef: UIButton!
    static let identifier = "WatchHistoryTableViewCell"
    var onClickPlay : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onClickPlay(_ sender: UIButton) {
        self.onClickPlay?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib() -> UINib {
        return UINib(nibName: "WatchHistoryTableViewCell", bundle: nil)
    }
 
}
