//
//  SATVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 08/03/21.
//

import UIKit

class SATVC: UIViewController {
    
    @IBOutlet weak var satTableView: customTblView!
    var  items = ["Maths","Math Practice Videos","English Practice Videos"]
    var indexArray = [Int]()
    var arrList = [NSDictionary]()
    
    @IBOutlet weak var viewFooter: Footerview!
    
    var refreshTbl: UIRefreshControl!
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var collFeatureCat: UICollectionView! {
        didSet {
            collFeatureCat.dataSource = self
            collFeatureCat.delegate = self
        }
    }
    
    @IBOutlet weak var viewSwipe: UIView!

    var indexSwipe = 0
    var strHeader = ""
    var id = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewFooter.footerDelegate = self
        indexArray.append(0)
        lblHeader.text = strHeader
        refreshTbl = UIRefreshControl()
        refreshTbl.addTarget(self, action: #selector(onRefreshTbl), for: .valueChanged)
        satTableView.addSubview(refreshTbl)
        
        
     //   let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
//        leftSwipe.direction = .left
//        rightSwipe.direction = .right
//        self.viewSwipe.addGestureRecognizer(leftSwipe)
//        self.viewSwipe.addGestureRecognizer(rightSwipe)
//
        
        
        self.collFeatureCat?.register(UINib(nibName: "SATCVCell", bundle: nil), forCellWithReuseIdentifier: "SATCVCell")

        let indexPath = IndexPath(row: 0, section: 0)
        self.indexArray.removeAll()
        indexArray.append(0)
        collFeatureCat.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collFeatureCat.reloadData()
        callWebserviceGetdata()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
}





extension SATVC {
    
    func animationDuration() -> Double {
        return 0.5
    }
    
    
//    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
//
//        let duration = animationDuration()
//
//
//        if (sender.direction == .left) {
//            print("Swipe Left")
//
//            if(indexSwipe < self.items.count){
//                if(indexSwipe == self.items.count - 1){
//                }
//                else{
//                    indexSwipe += 1
//                    indexArray.removeAll()
//                    indexArray.append(indexSwipe)
//                  // let obj = self.items[indexSwipe]
//
//                    //                    if(indexSwipe == 0){
//                    //
//                    //                    }
////                    //                    else{
////                    lblTitle.text = obj
////                    self.cat_Id = obj.cat_id!
////                    self.belowArticleList_cat.removeAll()
////                    self.scrollIndex_cat = 1
////                    APIClient.showLoaderView(view: self.view)
////                    self.setbelowArticlesApiWithCatId(strCkeck: "get", cat_id: self.cat_Id)
//
//                    UIView.animate(withDuration: duration, animations: {
//                        let labelPosition = CGPoint(x: self.satTableView.frame.origin.x - self.satTableView.frame.size.width, y: self.satTableView.frame.origin.y)
//                        print(labelPosition)
//                        self.satTableView.frame = CGRect(x: labelPosition.x, y: labelPosition.y, width: self.satTableView.frame.size.width, height: self.satTableView.frame.size.height)
//
//                        self.collFeatureCat.scrollToItem(at: IndexPath(item: self.indexSwipe, section: 0), at: .centeredHorizontally, animated: true)
//                        self.collFeatureCat.reloadData()
//
//                    })
//                }
//            }
//        }
//
//        if (sender.direction == .right) {
//            print("Swipe Right")
//            if indexSwipe > 0 {
//                indexSwipe -= 1
//
//                indexArray.removeAll()
//                indexArray.append(indexSwipe)
//
//                UIView.animate(withDuration: duration, animations: {
//                    let labelPosition = CGPoint(x: self.satTableView.frame.origin.x + self.satTableView.frame.size.width, y: self.satTableView.frame.origin.y)
//                    self.satTableView.frame = CGRect(x: labelPosition.x, y: labelPosition.y, width: self.satTableView.frame.size.width, height: self.satTableView.frame.size.height)
//
//                    self.collFeatureCat.scrollToItem(at: IndexPath(item: self.indexSwipe, section: 0), at: .centeredHorizontally, animated: true)
//                    self.collFeatureCat.reloadData()
//                })
//            }
//        }
//    }
    
}

//group call
extension SATVC {
    
    func callWebserviceGetdata()  {
       // BaseApi.showActivityIndicator(icon: nil, text: "")
print(id)
        let request = NSMutableURLRequest(url: NSURL(string: "https://dev7.doubtnut.com/v7/library/getplaylist?page_no=1&id=\(id)&student_class=12")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NjYxNzA2OTEsImlhdCI6MTYxNDA2Nzk2NCwiZXhwIjoxNjc3MTM5OTY0fQ.szfJPzcYSvSPNQfT0EDPjGSmNlosjoWcJUP3SY1o1V8", forHTTPHeaderField: "x-auth-token")
        request.addValue("US", forHTTPHeaderField: "country")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                print("Response: \(String(describing: response))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        let jsonString = BaseApi.showParam(json: json)
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api", message: "Response: \(jsonString)", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let dataJson = json["data"] as? [String:AnyObject]{
                                                let arr = dataJson["list"] as! NSArray
                                                print(arr)
                                                if arr.count == 0{
                                                    self.showToast(message: "Data not Found")
                                                }
                                                if arrList.count>0 {
                                                    arrList.removeAll()
                                                }
                                                for objDict in arr {
                                                    arrList.append(objDict as! NSDictionary)
                                                }
                                                satTableView.reloadData()
                                                BaseApi.hideActivirtIndicator()

                                            }else{
                                                BaseApi.hideActivirtIndicator()
                                            }
                                            
                                            //
                                        }else{
                                            BaseApi.hideActivirtIndicator()
                                            
                                        }
                                        
                                    }
                                }
                            }else{
                                BaseApi.hideActivirtIndicator()

                            }
                        }

                        
                    }
                } catch let error {
                    OperationQueue.main.addOperation {
                        self.showToast(message: "Something Went Wrong")
                        
                        BaseApi.hideActivirtIndicator()
                        
                        print(error.localizedDescription)
                    }
                    
                }
            }
        })
        
        task.resume()
    }
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    @objc func onRefreshTbl() {
        
        run(after: 2) {
//            self.scrollIndex_cat = 1
//            self.belowArticleList_cat = []
//            APIClient.showLoaderView(view: self.view)
//            self.setbelowArticlesApiWithCatId(strCkeck: "get", cat_id: self.cat_Id)
            
            self.refreshTbl.endRefreshing()
        }
    }
}




extension SATVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblCell", for: indexPath) as! tblCell
        
        let obj = arrList[indexPath.row]
        cell.lblTitle.text = obj["name"] as? String
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension SATVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SATCVCell", for: indexPath) as? SATCVCell else { return UICollectionViewCell() }
            
            cell.lblSubjects.text = self.items[indexPath.row]
            
            if(indexArray.contains(indexPath.row)){
                cell.lblSubjects.textColor = .systemRed
                cell.lblSelectedLine.backgroundColor = .systemRed
                
            }
            else{
                cell.lblSubjects.textColor = .systemGray4
                cell.lblSelectedLine.backgroundColor = UIColor.clear
            }
            
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
            
            
            indexArray.removeAll()
            
            indexSwipe = indexPath.row
            
            indexArray.append(indexPath.row)
           // let obj = self.items[indexPath.row]
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let label = UILabel(frame: CGRect.zero)
            let obj = self.items[indexPath.row]
            label.text = obj
            label.sizeToFit()
            let itemWidth = label.frame.width + 40
            return CGSize(width: itemWidth  , height: 55)
    }
}



extension SATVC : FooterviewDelegate{
    func didPressFooterButton(getType: String) {
        if getType == "Home"{
            print(getType)
        }else if getType == "Doubt"{
            let vc = FlowController().instantiateViewController(identifier: "CustomCameraVC", storyBoard: "Home")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print(getType)
            
            let vc = FlowController().instantiateViewController(identifier: "navProfile", storyBoard: "Profile") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
present(vc, animated: false, completion: nil)
        }
    }
    
}





class customTblView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}

class tblCell : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
}

