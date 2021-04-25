//
//  HomeTVCell.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 25/04/21.
//

import UIKit
import SDWebImage

class HomeTVCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnOutletSeeAll: UIButton!
    @IBOutlet weak var itemsCollectionview: UICollectionView!
    var arrItem = [NSDictionary]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.itemsCollectionview.register(UINib(nibName: "MathCVCell", bundle: nil), forCellWithReuseIdentifier: "MathCVCell")
        itemsCollectionview.delegate = self
        itemsCollectionview.dataSource = self


    }
    static func nib() -> UINib {
        return UINib(nibName: "HomeTVCell", bundle: nil)
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(feedDict:NSDictionary){
        if let objWidgetData = feedDict["widget_data"] as? NSDictionary {
            lblTitle.text = objWidgetData["title"] as? String
        
            if let itemArry = objWidgetData["items"] as? NSArray{
                for objItem in itemArry {
                    arrItem.append(objItem as! NSDictionary)
                }
            }
            itemsCollectionview.reloadData()
        }
      
    }
    
}

extension HomeTVCell : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = itemsCollectionview.dequeueReusableCell(withReuseIdentifier: "MathCVCell", for: indexPath) as! MathCVCell
        let objDict = arrItem[indexPath.row]
       
        cell.lblTItle.text = objDict["title"] as? String
        if let url = objDict["image_url"] as? String{
            cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgView.contentMode = .scaleToFill
        cell.imgView.sd_setImage(with: URL.init(string: url), completed: nil)
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemsCollectionview.frame.width - 50, height: itemsCollectionview.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        viewFreeTrial.isHidden = false
    }
    
}
