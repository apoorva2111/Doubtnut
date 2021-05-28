//
//  ACTVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 09/03/21.
//

import UIKit
import SDWebImage
class ResultListVC: UIViewController {
    @IBOutlet weak var tblResult: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    
    var Id = 0
    var name = ""
    var arrList = [NSDictionary]()
    var currentPage : Int = 1
    var checkPagination = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Id)
        print(name)
        lblHeader.text = name
        tblResult.isHidden = true
        tblResult.register(UINib.init(nibName: "ResultTVCell", bundle: nil), forCellReuseIdentifier: "ResultTVCell")
        self.checkPagination == "get"
        callResultList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblResult.estimatedRowHeight = 200.0// the estimated row height ..the closer the better
        tblResult.rowHeight = UITableView.automaticDimension

    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 
    func callResultList() {
        BaseApi.showActivityIndicator(icon: nil, text: "")

         let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v8/library/getresource?page_no=\(currentPage)&id=\(Id)&auto_play_data=0&supported_media_type=DASH%2CHLS%2CRTMP%2CBLOB%2CYOUTUBE")! as URL)
         let session = URLSession.shared
         request.httpMethod = "GET"
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         
         if let auth = userDef.value(forKey: "Auth_token") as? String{
             request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Njk5NTkzNTIsImlhdCI6MTYyMDY0MjI5MCwiZXhwIjoxNjgzNzE0MjkwfQ.oSDqsry8VS6Q0dXcasv5sqqgZ02rTCwvtAaYcy5I7CI", forHTTPHeaderField: "x-auth-token")
         }
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("US", forHTTPHeaderField: "country")
         request.addValue("844", forHTTPHeaderField: "version_code")

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
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.app/v8/library/getresource?page_no=\(self.currentPage)&id=\(self.Id)&auto_play_data=0&supported_media_type=DASH%2CHLS%2CRTMP%2CBLOB%2CYOUTUBE", message: "Response: \(jsonString)     version_code:- 844", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                             
                             if checkBtn == "OK"{
                                 
                                 OperationQueue.main.addOperation { [self] in
                                     if let meta = json["meta"] as? [String:AnyObject]{
                                         let code = meta["code"] as! Int
                                         if code == 200 {
                                             if let dataJson = json["data"] as? NSDictionary{
                                                if let dataPlay = dataJson["playlist"] as? NSArray{
                                                    print(dataPlay)
                                                    if self.checkPagination == "get"{
                                                        self.arrList.removeAll()
                                                    }
                                                    for obj in dataPlay{
                                                       arrList.append(obj as! NSDictionary)
                                                    }

                                                }
                                                if arrList.count>0{
                                                    tblResult.isHidden = false
                                                }else{
                                                    tblResult.isHidden = true
                                                }
                                                tblResult.reloadData()
                                                 BaseApi.hideActivirtIndicator()
                                                 
                                             }else{
                                                 BaseApi.hideActivirtIndicator()
                                             }
                                         }else{
                                             BaseApi.hideActivirtIndicator()
                                         }
                                         
                                     }else{
                                        BaseApi.hideActivirtIndicator()
                                     }
                                 }
                             }else{
                                 BaseApi.hideActivirtIndicator()

                             }
                         }
                         
                     }
                 } catch let error {
                     self.showToast(message: "Something Went Wrong")
                     
                     BaseApi.hideActivirtIndicator()
                     
                     print(error.localizedDescription)
                 }
             }
         })
         
         task.resume()
     }

}

extension ResultListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblResult.dequeueReusableCell(withIdentifier: "ResultTVCell", for: indexPath) as! ResultTVCell
        let obj = arrList[indexPath.row]
        if let quesid = obj["question_id"] as? Int{
            cell.lblId.text = String(quesid)
        }
        if let imgurl = obj["thumbnail_image"] as? String{
            cell.imgThumbnil.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgThumbnil?.contentMode = .scaleAspectFit
           
            if let ocrtext = obj["ocr_text"] as? String{
                
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: ocrtext, options: [], range: NSRange(location: 0, length: ocrtext.utf16.count))

                for match in matches {
                    guard let range = Range(match.range, in: ocrtext) else { continue }
                    let url = ocrtext[range]
                    print(url)
                    if url == "" {
                        cell.imgThumbnil.isHidden = true
                    }else{
                        cell.imgThumbnil.isHidden = false
                        cell.imgThumbnil?.sd_setImage(with: URL.init(string: String(url)), completed: nil)

                    }
                }
                if matches.count == 0 {
                    cell.imgThumbnil.isHidden = true 
                }
                
            }
            
            
                    if let ocrText = obj["ocr_text"] as? String{
                        
                        cell.lblText.text = ocrText.html2String
                    }

        }

        if let duretion = obj["duration"] as? String{
//            let time = secondsToHoursMinutesSeconds(seconds: Int(duretion) ?? 0)
//            print(time)
            let time = Int(duretion) ?? 0
            let minute = (time  % 3600) / 60
            let second = (time % 3600) % 60
            cell.lblTime.text = String(format: "%02d:%02d", minute, second)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrList[indexPath.row]
        print(obj)
        let vc = FlowController().instantiateViewController(identifier: "PlayVideoVC", storyBoard: "PlayVideo") as! PlayVideoVC
        /**/
        vc.videDictionary = obj as! NSMutableDictionary
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                if indexPath.row == arrList.count-1{
                    self.checkPagination = "pagination"
                    currentPage += 1
                    run(after: 2) {
                        self.callResultList()
                    }
                }
            }
        }
    }
       
}
/*
 */
