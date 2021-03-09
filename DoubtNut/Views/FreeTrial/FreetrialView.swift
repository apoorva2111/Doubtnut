//
//  FreetrialView.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 07/03/21.
//

import UIKit
protocol FreetrialViewDelegate{
    
    func didPressCrossButton(Tag:Int)
    func didStartStudingAction()
    func didKeepMyMembershipAction()
    func didCancelMembershipAction()
    func didDayExtendAction()
    func didDontWontItAction()
}
class FreetrialView: UIView {
    @IBOutlet weak var viewStartStudying: UIView!
   
    
    @IBOutlet weak var viewMembership: UIView!
    @IBOutlet weak var viewGiveAnotherChange: UIView!
    @IBOutlet weak var lblGiveAnotherChance: UILabel!
    @IBOutlet weak var lblTellUsWhatWent: UILabel!
    @IBAction func btnGiveAnotherChangeRadio(_ sender: UIButton) {
    }
    @IBOutlet weak var btnOutletDayExtend: RCustomButton!
    
    @IBOutlet weak var btnOutletdontWant: UIButton!
  
    let nibName = "FreetrialView"
    var contentView: UIView?
    var freetrialViewDelegate : FreetrialViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        view.frame = self.bounds
        setView()
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    func setView()  {
        viewMembership.isHidden = true
        viewStartStudying.isHidden = false
        viewGiveAnotherChange.isHidden = true
    }
}
extension FreetrialView{
    @IBAction func btnCloseAction(_ sender: UIButton) {
        freetrialViewDelegate.didPressCrossButton(Tag: sender.tag)
    }
    
    @IBAction func btnStartStuding(_ sender: UIButton) {
        freetrialViewDelegate.didStartStudingAction()
    }
    
    @IBAction func btnKeepMyMembershipAction(_ sender: UIButton) {
        freetrialViewDelegate.didKeepMyMembershipAction()
    }
   
    @IBAction func btnCancelMembershipAction(_ sender: UIButton) {
        freetrialViewDelegate.didCancelMembershipAction()
    }
    
    @IBAction func btnDayExtendAction(_ sender: UIButton) {
        freetrialViewDelegate.didDayExtendAction()
    }
  
    @IBAction func btnDontWontItAction(_ sender: UIButton) {
        freetrialViewDelegate.didDontWontItAction()
    }

}
