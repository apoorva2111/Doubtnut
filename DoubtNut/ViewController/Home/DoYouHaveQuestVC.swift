//
//  DoYouHaveQuestVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 12/03/21.
//

import UIKit
import SDWebImage

class DoYouHaveQuestVC: UIViewController {
    var viewController : UIViewController?
    @IBOutlet weak var viewPager: UIView!
    @IBOutlet weak var viewDoyouHaveQues: UIView!
    @IBOutlet weak var viewCollectionGif: UIView!
    
    @IBOutlet weak var imgQues: UIImageView!
    
  //  let cellWidth =
    let sectionSpacing = 0
    let cellSpacing = 0
    let layout = PagingCollectionViewLayout()
    var arrTitle = [NSDictionary]()
    var arrSubjectList = [NSDictionary]()
    // MARK: - UI Components
    
    lazy var collectionviewGIF: UICollectionView = {
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: CGFloat(sectionSpacing), bottom: 0, right: CGFloat(sectionSpacing))
        layout.itemSize = CGSize(width: viewCollectionGif.frame.size.width, height: viewCollectionGif.frame.size.height)
        layout.minimumLineSpacing = CGFloat(cellSpacing)
        let collectionView = UICollectionView(frame:viewCollectionGif.frame , collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if BoolValue.isFromImog {
            BoolValue.isFromImog = false
            viewPager.isHidden = false
            viewDoyouHaveQues.isHidden = true
            
            self.collectionviewGIF.register(UINib(nibName: "PagerCVCell", bundle: nil), forCellWithReuseIdentifier: "PagerCVCell")

            applyConstraints()
            
            

        }else{
            viewPager.isHidden = true
            viewDoyouHaveQues.isHidden = false
            if arrSubjectList.count>0{
                let objsubject = arrSubjectList[0]
                let imgUrl = objsubject["imageUrl"] as? String
                imgQues.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                imgQues.sd_setImage(with: URL(string: imgUrl!), completed: nil)
                
            }        }

        // Do any additional setup after loading the view.
    }
    private func applyConstraints() {
        
        self.viewCollectionGif.addSubview(collectionviewGIF)
        collectionviewGIF.translatesAutoresizingMaskIntoConstraints = false
        collectionviewGIF.topAnchor.constraint(equalTo: self.viewCollectionGif.topAnchor).isActive = true
        collectionviewGIF.bottomAnchor.constraint(equalTo: self.viewCollectionGif.bottomAnchor).isActive = true
        collectionviewGIF.leadingAnchor.constraint(equalTo: self.viewCollectionGif.leadingAnchor, constant: 0).isActive = true
        collectionviewGIF.trailingAnchor.constraint(equalTo: self.viewCollectionGif.trailingAnchor, constant: 0).isActive = true
    }
    
    
    @IBAction func btnPagerClose(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height + 200, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        })
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
        let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home") as! DashboardVC
        self.navigationController?.pushViewController(vc, animated: true)
   
    }
   
}
extension DoYouHaveQuestVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PagerCVCell", for: indexPath) as! PagerCVCell
        let objTitle = arrTitle[indexPath.row]
        cell.lblTitle.text = objTitle["title"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitle.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionviewGIF.frame.width, height: collectionviewGIF.frame.height)
    }
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

