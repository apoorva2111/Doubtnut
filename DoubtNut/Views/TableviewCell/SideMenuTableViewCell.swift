//
//  SideMenuTableViewCell.swift
//  DoubtNut
//
//  Created by Mohammed Sulaiman on 09/03/21.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var sideMenuImage: UIImageView!
    @IBOutlet weak var sideMenuTitle: UILabel!
    
    @IBOutlet weak var viewChangeLanguage: UIView!
    
    @IBOutlet weak var viewLoginPin: UIView!
    
    @IBOutlet weak var viewChangeClass: UIView!
    
    @IBOutlet weak var changePinOutlt: UIButton!
    
    @IBOutlet weak var lblClass: UIButton!
  
    @IBOutlet weak var lblLanguage: UIButton!
  
    @IBOutlet weak var lblPinOne: UILabel!
    @IBOutlet weak var lblPinTwo: UILabel!
    @IBOutlet weak var lblPinThree: UILabel!
    @IBOutlet weak var lblPinFour: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onClickChangePIn(_ sender: UIButton) {
    }
    
    
    @IBAction func onClickGradeButton(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
