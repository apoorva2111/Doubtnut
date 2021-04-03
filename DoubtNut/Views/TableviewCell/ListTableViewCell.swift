//
//  ListTableViewCell.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 12/03/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblVideoID: UILabel!
   @IBOutlet weak var lblVideoView: UILabel!
   @IBOutlet weak var lblVideoTime: UILabel!
    @IBOutlet weak var lblVideoLike: UILabel!
    @IBOutlet weak var imgThumbnil: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
