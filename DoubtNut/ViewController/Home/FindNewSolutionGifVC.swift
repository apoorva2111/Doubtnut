//
//  FindNewSolutionGifVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 12/03/21.
//

import UIKit
import Lottie

class FindNewSolutionGifVC: UIViewController {
    var animation: AnimationView!

    @IBOutlet weak var viewShowGif: UIView!
  
    @IBOutlet weak var lblText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playAnimation()
    }
    
    func playAnimation(){
        
        if animation != nil{
            animation.removeFromSuperview()
        }
        animation = AnimationView.init(name: "loader_1")
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        
        self.viewShowGif.addSubview(animation)
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.topAnchor.constraint(equalTo: self.viewShowGif.topAnchor).isActive = true
        animation.bottomAnchor.constraint(equalTo: self.viewShowGif.bottomAnchor).isActive = true
        animation.leadingAnchor.constraint(equalTo: self.viewShowGif.leadingAnchor, constant: 0).isActive = true
        animation.trailingAnchor.constraint(equalTo: self.viewShowGif.trailingAnchor, constant: 0).isActive = true
        print(animation.frame)
        animation.play()
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
