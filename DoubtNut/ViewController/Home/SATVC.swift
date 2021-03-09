//
//  SATVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 08/03/21.
//

import UIKit

class SATVC: UIViewController {
    @IBOutlet weak var satCollection: UICollectionView!
    
    @IBOutlet weak var satTableView: UITableView!
    var  arrSubject = ["Maths","Math Practice Videos","English Practice Videos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerNib()
    }
    func registerNib() {
        self.satCollection.register(UINib(nibName: "SATCVCell", bundle: nil), forCellWithReuseIdentifier: "SATCVCell")

    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK :- UICollection view
extension SATVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = satCollection.dequeueReusableCell(withReuseIdentifier: "SATCVCell", for: indexPath) as! SATCVCell
        cell.lblSubjects.text = arrSubject[indexPath.row]
        cell.lblSelectedLine.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
