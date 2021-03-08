//
//  Footerview.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 08/03/21.
//

import UIKit
protocol FooterviewDelegate{
    
    func didPressFooterButton(getType:String)
}
class Footerview: UIView {
    
    let nibName = "Footerview"
    var contentView: UIView?
    var footerDelegate : FooterviewDelegate!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var lblHome: UILabel!
  
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblProfile: UILabel!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        view.frame = self.bounds
//        view.layer.cornerRadius = 20
//        view.layer.borderColor = UIColor.white.cgColor
//        view.layer.borderWidth = 1
//
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
   
    @IBAction func btnFooterSelectAction(_ sender: UIButton) {
        if sender.tag == 10 {
            footerDelegate.didPressFooterButton(getType: "Home")
        }else if sender.tag == 20{
            footerDelegate.didPressFooterButton(getType: "Doubt")

        }else{
            footerDelegate.didPressFooterButton(getType: "Profile")
        }
    }
    
}
