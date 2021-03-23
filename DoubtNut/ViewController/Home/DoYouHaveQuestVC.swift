//
//  DoYouHaveQuestVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 12/03/21.
//

import UIKit

class DoYouHaveQuestVC: UIViewController {
    var viewController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnTryExampleAction(_ sender: UIButton) {
        BoolValue.isFromDoyouhaveQues = true
        viewController?.viewWillAppear(true)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height + 200, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        })
    }
    @IBAction func btnSkipLearningAction(_ sender: UIButton) {
        let mainVC = FlowController().instantiateViewController(identifier: "navHome", storyBoard: "Home")
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = mainVC
        appDel.window?.makeKeyAndVisible()
   
    }
   
}
