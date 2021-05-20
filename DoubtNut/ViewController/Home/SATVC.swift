//
//  SATVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 08/03/21.
//

import UIKit

class SATVC: UIViewController {
    
    @IBOutlet weak var satTableView: customTblView!
    var indexArray = [Int]()
    var indexFilterArray = [Int]()

    var arrList = [NSDictionary]()
    var arrHeader = [NSDictionary]()
    var arrFilter = [NSDictionary]()
    

    @IBOutlet weak var collectionFilterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCollectionHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionFilter: UICollectionView!
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
        
        
        self.collFeatureCat?.register(UINib(nibName: "SATCVCell", bundle: nil), forCellWithReuseIdentifier: "SATCVCell")
        self.collectionFilter?.register(UINib(nibName: "SATCVCell", bundle: nil), forCellWithReuseIdentifier: "SATCVCell")

        viewCollectionHeaderHeightConstraint.constant = 0
        collectionFilterHeightConstraint.constant = 0
        satTableView.isHidden = true
        let indexPath = IndexPath(row: 0, section: 0)
        self.indexArray.removeAll()
        indexArray.append(0)
        collFeatureCat.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collFeatureCat.reloadData()
        callWebserviceGetdata(id: id)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           
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

    
}

//group call
extension SATVC {
 
    func callWebserviceGetdata(id:String)  {
       BaseApi.showActivityIndicator(icon: nil, text: "")
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v7/library/getplaylist?page_no=1&id=\(id)&student_class=27")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
       // let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Njk5NTkzNTIsImlhdCI6MTYyMDY0MjI5MCwiZXhwIjoxNjgzNzE0MjkwfQ.oSDqsry8VS6Q0dXcasv5sqqgZ02rTCwvtAaYcy5I7CI", forHTTPHeaderField: "x-auth-token")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("847", forHTTPHeaderField: "version_code")

        
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
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api,  URL:- https://api.doubtnut.app/v7/library/getplaylist?page_no=1&id=\(self.id)&student_class=27", message: "Response: \(jsonString)     version_code:-847", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let dataJson = json["data"] as? [String:AnyObject]{
                                                if let filter = dataJson["filters"] as? NSArray{
                                                    if arrFilter.count>0 {
                                                        arrFilter.removeAll()
                                                    }
                                                    for objfilter in filter {
                                                        arrFilter.append(objfilter as! NSDictionary)
                                                    }
                                                    indexFilterArray.removeAll()
                                                    indexFilterArray.append(0)

                                                    
                                                    if arrFilter.count>0{
//
                                                        collectionFilterHeightConstraint.constant = 40
                                                        collectionFilter.reloadData()
                                                    }
                                                    
                                                    
                                                }
                                                if let header = dataJson["headers"] as? NSArray{
                                                    if arrHeader.count>0 {
                                                        arrHeader.removeAll()
                                                    }
                                                    for objHeader in header {
                                                        arrHeader.append(objHeader as! NSDictionary)
                                                    }
                                                    if arrHeader.count>0{
                                                        viewCollectionHeaderHeightConstraint.constant = 70
                                                        collFeatureCat.reloadData()
                                                    }
                                                }
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
                                                if arrList.count>0{
                                                    satTableView.isHidden = false
                                                    satTableView.reloadData()
                                                }else{
                                                    satTableView.isHidden = true
                                                }
                                                
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
                        UtilesSwift.shared.displayAlertWithHandler(with: "ERROR", message: error.localizedDescription, buttons: ["OK"], viewobj: self) { (btn) in
                            
                        }
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
            self.callWebserviceGetdata(id: self.id)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrList[indexPath.row]
        let vc   = FlowController().instantiateViewController(identifier: "ResultListVC", storyBoard: "Home") as! ResultListVC
        vc.Id = obj["id"] as? Int ?? 0
        vc.name = obj["name"] as? String ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SATVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionFilter{
            return arrFilter.count
        }else{
        return arrHeader.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SATCVCell", for: indexPath) as? SATCVCell else { return UICollectionViewCell() }
            
        if collectionView == collectionFilter{
            let obj = arrFilter[indexPath.row]
            cell.lblSubjects.text = obj["name"] as? String
            cell.viewBG.backgroundColor = .white
//            cell.lblSubjects.textColor = .systemRed
            cell.lblSelectedLine.backgroundColor = .clear
            if arrFilter.count == 1{
                cell.viewBG.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                cell.viewBG.layer.cornerRadius = 5
                cell.lblSubjects.textColor = .white
                cell.viewBG.clipsToBounds = true
            }else{
                if(indexFilterArray.contains(indexPath.row)){
                    cell.viewBG.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)
                    cell.viewBG.layer.cornerRadius = 5
                    cell.lblSubjects.textColor = .white
                    cell.viewBG.clipsToBounds = true

                }
                else{
                    cell.viewBG.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
                    cell.viewBG.layer.cornerRadius = 5
                    cell.lblSubjects.textColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.1725490196, alpha: 1)

                    cell.viewBG.clipsToBounds = true
                }
              
            }
            
            
            
        }else{
            let obj = arrHeader[indexPath.row]
            cell.lblSubjects.text = obj["name"] as? String
            cell.viewBG.backgroundColor = .white
            if(indexArray.contains(indexPath.row)){
                cell.lblSubjects.textColor = .systemRed
                cell.lblSelectedLine.backgroundColor = .systemRed
                
            }
            else{
                cell.lblSubjects.textColor = .black
                cell.lblSelectedLine.backgroundColor = UIColor.clear
            }
        }
        
        
            
            
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collectionFilter{
            let obj = arrFilter[indexPath.row]
            let headerId = obj["id"] as? Int ?? 0
            callWebserviceGetdata(id:String(headerId))
            indexFilterArray.removeAll()
            if arrFilter.count>1{
                indexSwipe = indexPath.row
                indexFilterArray.append(indexPath.row)
            }else{
                indexSwipe = 0
                indexFilterArray.append(0)
            }
            collectionFilter.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionFilter.reloadData()
        }else{
            let obj = arrHeader[indexPath.row]
            let headerId = obj["id"] as? Int ?? 0
            callWebserviceGetdata(id:String(headerId))
            indexArray.removeAll()
            if arrHeader.count>1{
                indexSwipe = indexPath.row
                indexArray.append(indexPath.row)
            }else{
                indexSwipe = 0
                indexArray.append(0)
            }
            
            for i in 0..<arrFilter.count{
                indexFilterArray.append(i)
            }
            
            
            collFeatureCat.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collFeatureCat.reloadData()
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionFilter{
        
            let label = UILabel(frame: CGRect.zero)
            let obj = self.arrFilter[indexPath.row]
            label.text = obj["name"] as? String
            label.sizeToFit()
            let itemWidth = label.frame.width + 40
            return CGSize(width: itemWidth  , height: 40)
        }else{
            let label = UILabel(frame: CGRect.zero)
            let obj = self.arrHeader[indexPath.row]
            label.text = obj["name"] as? String
            label.sizeToFit()
            let itemWidth = label.frame.width + 40
            return CGSize(width: itemWidth  , height: 40)
        }
           
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

