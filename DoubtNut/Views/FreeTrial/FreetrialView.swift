//
//  FreetrialView.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 07/03/21.
//

import UIKit

class FreetrialView: UIView {
    let nibName = "FreetrialView"
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        view.frame = self.bounds
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
  
}
