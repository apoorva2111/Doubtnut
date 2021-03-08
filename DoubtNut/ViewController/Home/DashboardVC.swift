//
//  DashboardVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 06/03/21.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var viewFooterview: Footerview!
    @IBOutlet weak var collectionMaths: UICollectionView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFooterview.footerDelegate = self
        // Do any additional setup after loading the view.
        registerXib()
    }
    func registerXib() {
        self.collectionMaths.register(UINib(nibName: "MathCVCell", bundle: nil), forCellWithReuseIdentifier: "MathCVCell")

    }

  

}
extension DashboardVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionMaths.dequeueReusableCell(withReuseIdentifier: "MathCVCell", for: indexPath) as! MathCVCell
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionMaths.frame.width - 50, height: collectionMaths.frame.height)
    }
    
}
extension DashboardVC{
    @IBAction func btnSATAction(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "SATVC", storyBoard: "Home")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnACTAction(_ sender: Any) {
        let vc = FlowController().instantiateViewController(identifier: "SATVC", storyBoard: "Home")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension DashboardVC : FooterviewDelegate{
    func didPressFooterButton(getType: String) {
        if getType == "Home"{
            print(getType)
        }else if getType == "Doubt"{
            print(getType)
        }else{
            print(getType)
        }
    }
    
}
