//
//  LandingpageVC.swift
//  doubtnut
//
//  Created by Apoorva Gangrade on 04/03/21.
//

import UIKit
import Lottie

class LandingpageVC: UIViewController, UIScrollViewDelegate {
    var animation: AnimationView!
    
    @IBOutlet weak var viewLeadingpagGif: UIView!

    @IBAction func btnSignUpAction(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "LoginwithPincode", storyBoard: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }

   
    let nibNamewalkthrough = "LandingPageSlider"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playAnimation()
    }
    //Show Lottie image
    func playAnimation(){
        
        if animation != nil{
            animation.removeFromSuperview()
        }
        animation = AnimationView.init(name: "ios onboard")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        
        self.viewLeadingpagGif.addSubview(animation)
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.topAnchor.constraint(equalTo: self.viewLeadingpagGif.topAnchor).isActive = true
        animation.bottomAnchor.constraint(equalTo: self.viewLeadingpagGif.bottomAnchor).isActive = true
        animation.leadingAnchor.constraint(equalTo: self.viewLeadingpagGif.leadingAnchor, constant: 0).isActive = true
        animation.trailingAnchor.constraint(equalTo: self.viewLeadingpagGif.trailingAnchor, constant: 0).isActive = true
        print(animation.frame)
        animation.play()
    }
}
