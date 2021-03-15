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
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var loginImageView: UIImageView!
    
    @IBOutlet weak var loginBaseStakView: UIStackView!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var loginPinStackView: UIStackView!
    
    @IBOutlet weak var firstPinTextField: UITextField!
    
    @IBOutlet weak var secondPinTextField: UITextField!
    
    @IBOutlet weak var ThirdPinTextField: UITextField!
    
    @IBOutlet weak var fourthPinTextField: UITextField!
    @IBOutlet weak var chanepinRefBtn: UIButton!
    
    
    @IBOutlet weak var changeGradeView: UIView!
    
    @IBOutlet weak var gradeImageView: UIImageView!
    
    @IBOutlet weak var gradeStackView: UIStackView!
    
    @IBOutlet weak var gradeTitleLabel: UILabel!
    
    @IBOutlet weak var GradeButtonRef: UIButton!
    
    
    
    
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

        // Configure the view for the selected state
    }
    
}
