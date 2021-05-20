//
//  ResultTVCell.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 17/05/21.
//

import UIKit

class ResultTVCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgThumbnil: UIImageView!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblWatch: UILabel!
    @IBOutlet weak var lblTime: RCustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
