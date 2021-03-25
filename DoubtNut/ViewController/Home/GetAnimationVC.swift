//
//  GetAnimationVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 25/03/21.
//

import UIKit
import Lottie

class GetAnimationVC: UIViewController {
  
    var animation: AnimationView!
    var arrAnimationTitle = [NSDictionary]()

    @IBOutlet weak var tbleAnimation: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tbleAnimation.register(UINib(nibName: "GetAnimationTVCell", bundle: nil), forCellReuseIdentifier: "GetAnimationTVCell")
        
        tbleAnimation.delegate = self
        tbleAnimation.dataSource = self
        
        callWebserviceGetAnimation()
    }
    

    @IBAction func btnCLoseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GetAnimationVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAnimationTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbleAnimation.dequeueReusableCell(withIdentifier: "GetAnimationTVCell", for: indexPath) as! GetAnimationTVCell
        let objAnimation = arrAnimationTitle[indexPath.row]
       
        cell.lblTitle.text = objAnimation["title"] as? String
        cell.lblFooter.text = objAnimation["footer"] as? String
       
        if indexPath.row == 0{
            
            playAnimation(view: cell.viewGif, json: "data")
        }else if indexPath.row == 1{
            playAnimation(view: cell.viewGif, json: "data")

        }else {
            playAnimation(view: cell.viewGif, json: "data")

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func playAnimation(view:UIView,json:String){
        
        if animation != nil{
            animation.removeFromSuperview()
        }
        animation = AnimationView.init(name: json)
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        
        view.addSubview(animation)
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        animation.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        animation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        animation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        print(animation.frame)
        animation.play()
    }
}
//MARK:- Api calling
extension GetAnimationVC{
    func callWebserviceGetAnimation(){
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v1/camera/get-animation")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("850", forHTTPHeaderField: "version_code")
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
                        OperationQueue.main.addOperation { [self] in
                            if let meta = json["meta"] as? [String:AnyObject]{
                                let code = meta["code"] as! Int
                                if code == 200 {
                                    if let data = json["data"] {
                                        let arrTitle = data as! NSArray
                                        for objTitle in arrTitle {
                                            self.arrAnimationTitle.append(objTitle as! NSDictionary)
                                            
                                        }
                                        tbleAnimation.reloadData()
                                    }
                                    
                                    //
                                }else{
                                    BaseApi.hideActivirtIndicator()
                                    
                                }
                                
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
