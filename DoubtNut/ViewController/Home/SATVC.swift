//
//  SATVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 08/03/21.
//

import UIKit

class SATVC: UIViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
