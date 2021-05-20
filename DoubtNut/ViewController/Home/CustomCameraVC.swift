//
//  CustomCameraVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 10/03/21.
//

import UIKit
import AVFoundation
import AKImageCropperView
import Vision
import SDWebImage
class CustomCameraVC: UIViewController, AVCapturePhotoCaptureDelegate  {
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewImgCrop: UIView!
    @IBOutlet weak var viewCropImg: AKImageCropperView!
    private var cropViewProgrammatically: AKImageCropperView!
    @IBOutlet weak var imgFlash: UIImageView!
    @IBOutlet weak var viewCropOneQues: UIView!
    @IBOutlet weak var viewLearnPopUp: UIView!
    @IBOutlet weak var lblLernText: UILabel!
    @IBOutlet weak var btnImogOutlet: UIButton!
    @IBOutlet weak var btnCameraOutlet: UIButton!
    
    @IBOutlet weak var viewDontHave: UIView!
    @IBOutlet weak var viewDontHaveHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblOnlyCropOneQues: UILabel!
    @IBOutlet weak var viewTypeTxt: UIView!
    @IBOutlet weak var viewTypeTextTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtTypeText: UITextView!
    
    //  MARK: - Properties
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var flash: AVCaptureDevice.FlashMode = .off
    var CountIndex = 0
    var angle: Double = 0.0
    var arrSubjectList = [NSDictionary]()
var demoQuesCount = 0
    // var image: UIImage!
    
    private var cropView: AKImageCropperView {
        return cropViewProgrammatically ?? viewCropImg
    }
    
    var arrAnimationTitle = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewTypeTextTopConstraint.constant = -200
        txtTypeText.delegate = self
        callWebserviceGetAnimation()
        // Do any additional setup after loading the view.
        viewImgCrop.isHidden = true
        viewCropOneQues.isHidden = true
        viewLearnPopUp.isHidden = true
        btnImogOutlet.isHidden  = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.batteryLevelChanged),
            name: NSNotification.Name(rawValue: "NotificationIdentifier"),
            object: nil)
     //  if (userDef.value(forKey: "donthaveques") != nil) == false{
        if let demoquesCount = userDef.value(forKey: "DemoQues"){
            demoQuesCount  = demoquesCount as! Int
            demoQuesCount += 1
            userDef.setValue(demoQuesCount, forKey: "DemoQues")
            userDef.synchronize()

            if demoQuesCount > 3{
                self.viewDontHave.isHidden = true
                self.viewDontHaveHeightConstraint.constant = 0
            }else{
                self.viewDontHave.isHidden = false
                self.viewDontHaveHeightConstraint.constant = 80
            }
        }else{
            userDef.setValue(1, forKey: "DemoQues")
            userDef.synchronize()

            self.viewDontHave.isHidden = false
            self.viewDontHaveHeightConstraint.constant = 80
        }
//        }else{
//            self.viewDontHave.isHidden = true
//            self.viewDontHaveHeightConstraint.constant = 0
//        }
    }
    @objc private func batteryLevelChanged(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        viewWillAppear(true)
        viewDidAppear(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCameraAccess()
        toggleTorch(on: false)

        if BoolValue.isFromDoyouhaveQues{
            BoolValue.isFromDoyouhaveQues = false
            callWebserviceGetDemo()
        }
            var count = userDef.integer(forKey: UserDefaultKey.cameraCount)
                count += 1
            userDef.setValue(count, forKey: UserDefaultKey.cameraCount)
            userDef.synchronize()
        callWebserviceGetSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill//resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        viewCamera.layer.addSublayer(videoPreviewLayer)
        
        //Step12
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.viewCamera.bounds
            }
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        
        let image = UIImage(data: imageData)
        cropView.delegate = self
        cropView.image = image
        cropView.contentMode = .scaleAspectFit
        
        viewImgCrop.isHidden = false
        viewCropOneQues.isHidden = false
        
        
//        if cropView.isOverlayViewActive {
//
//            cropView.hideOverlayView(animationDuration: 0.3)
//
//            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
//                //    self.overlayActionView.alpha = 0
//
//            }, completion: nil)
//
//        } else {
            
            cropView.showOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                //     self.overlayActionView.alpha = 1
                
            }, completion: nil)
            
        //}
    }
    
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                    imgFlash.image = #imageLiteral(resourceName: "Group 308")
                } else {
                    device.torchMode = .off
                    imgFlash.image = #imageLiteral(resourceName: "Group 309")
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
//  MARK: - AKImageCropperViewDelegate

extension CustomCameraVC: AKImageCropperViewDelegate {
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            btnCameraOutlet.isUserInteractionEnabled = false
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
            btnCameraOutlet.isUserInteractionEnabled = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default: break
        }
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                      message: "Camera access is denied",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })

        present(alertController, animated: true)
    }
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
        print("New crop rectangle: \(rect)")
        print(view)
    }
    
}

//MARK :- Webservice Call
extension CustomCameraVC{
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
                        let jsonString = BaseApi.showParam(json: json)
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api,  URL:- https://api.doubtnut.app/v1/camera/get-animation", message: "Response: \(jsonString)     version_code:-850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK" {
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] {
                                                let arrTitle = data as! NSArray
                                                for objTitle in arrTitle {
                                                    self.arrAnimationTitle.append(objTitle as! NSDictionary)
                                                    
                                                }
                                                viewLearnPopUp.isHidden = false
                                                
                                                Timer.scheduledTimer(timeInterval: 5.0,
                                                                     target: self,
                                                                     selector: #selector(CustomCameraVC.update),
                                                                     userInfo: nil,
                                                                     repeats: true)
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

                        
                    }else{
                        print("error")
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
    
    func callWebserviceGetDemo() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v1/config/demo")! as URL)
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
                        let jsonString = BaseApi.showParam(json: json)
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api URL:- https://api.doubtnut.app/v1/config/demo", message: "Response: \(jsonString)     version_code:- 850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                
                                OperationQueue.main.addOperation {
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let objData = json["data"] as? [String:AnyObject] {
                                                self.viewLearnPopUp.isHidden = true
                                                self.viewCropOneQues.isHidden = false
                                                self.viewDontHave.isHidden = true
                                                self.viewDontHaveHeightConstraint.constant = 0
                                                self.lblOnlyCropOneQues.text = objData["demo_text1"] as? String
                                                let demoimg = objData["demo_ocr_image"] as! String
                                                
                                                let photoURL = URL(string: demoimg)
                                                
                                                self.cropView.delegate = self
                                                //                                                    self.image.sd_setImage(with: URL(string: imgDemo), completed: nil)
                                                
                                                DispatchQueue.global(qos: .userInitiated).async {
                                                    do{
                                                        let imageData: Data = try Data(contentsOf: photoURL!)
                                                        
                                                        DispatchQueue.main.async {
                                                            let imageData = UIImage(data: imageData)
                                                            
                                                            
                                                            
                                                            self.cropView.image = imageData
                                                            self.cropView.contentMode = .scaleAspectFit
                                                            
                                                            self.viewImgCrop.isHidden = false
                                                            self.viewCropOneQues.isHidden = false
                                                            
                                                            
        //                                                    if self.cropView.isOverlayViewActive {
        //
        //                                                        self.cropView.hideOverlayView(animationDuration: 0.3)
        //
        //                                                        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
        //                                                            //    self.overlayActionView.alpha = 0
        //
        //                                                        }, completion: nil)
        //
        //                                                    } else {
                                                                
                                                                self.cropView.showOverlayView(animationDuration: 0.3)
                                                                
                                                                UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                                                                    //     self.overlayActionView.alpha = 1
                                                                    
                                                                }, completion: nil)
                                                                
                                                         //   }

                                                        }
                                                    }catch{
                                                        print("Unable to load data: \(error)")
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                        //
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
    
    
    @objc func update() {
        
        if CountIndex > arrAnimationTitle.count-1{
            CountIndex = 0
        }
        
        let obj = arrAnimationTitle[CountIndex]
        lblLernText.text = obj["title"] as? String
        self.CountIndex += 1
        
    }
    
    func callawebServiewForGenerateUrl(imagevw : UIImage) {
        
        let Udid = UIDevice.current.identifierForVendor?.uuidString

        print(Udid!)
        let parameters :[String : Any] = ["class":12,
                         "subject":"physics",
                         "chapter":"magnetism",
                         "doubt":"maths",
                         "udid":Udid!,
                         "locale":"en",
                         "content_type":"image/png",
                         "file_ext":".png"]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.app/v1/question/generate-question-image-upload-url")! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("756", forHTTPHeaderField: "version_code")
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let jsonString = BaseApi.showParam(json: json)
                    UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.app/v1/question/generate-question-image-upload-url", message: "Response: \(jsonString)     version_code:- 756", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK" {
                            OperationQueue.main.addOperation {
                                print(json)
                                
                                if let meta = json["meta"] as? [String:AnyObject]{
                                    let code = meta["code"] as! Int
                                    if code == 200 {
                                        if let data = json["data"] as? [String:AnyObject]{
                                            print(data)
                                            let strUrl = data["url"] as? String
                                            let strfileName = data["file_name"] as? String
                                            let question_id = data["question_id"] as? Int
                                            let vc = FlowController().instantiateViewController(identifier: "FindNewSolutionGifVC", storyBoard: "Home") as! FindNewSolutionGifVC
                                            vc.imgUpload = imagevw
                                            vc.imgUploadURL = strUrl ?? ""
                                            vc.file_name = strfileName ?? ""
                                            vc.question_id = question_id ?? 0
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        
                                    }else{
                                        
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }
                        }else{
                            BaseApi.hideActivirtIndicator()

                        }
                    }

                    /**/
                    // handle json...
                }
            } catch let error {
                OperationQueue.main.addOperation {

                self.showToast(message: "Something Went Wrong")

                BaseApi.hideActivirtIndicator()

                print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
    func callWebserviceGetSetting() {
        let count = userDef.integer(forKey: UserDefaultKey.cameraCount)

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.doubtnut.app/v2/camera/get-settings?openCount=\(count)&studentClass=12")! as URL)
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
                        let jsonString = BaseApi.showParam(json: json)
                        UtilesSwift.shared.displayAlertWithHandler(with: "GET Api, URL:- https://api.doubtnut.app/v2/camera/get-settings?openCount=\(count)&studentClass=12", message: "Response: \(jsonString)     version_code:-850", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                            if checkBtn == "OK"{
                                OperationQueue.main.addOperation { [self] in
                                    if let meta = json["meta"] as? [String:AnyObject]{
                                        let code = meta["code"] as! Int
                                        if code == 200 {
                                            if let data = json["data"] as? [String:AnyObject] {
                                                let bottomOverlay = data["bottomOverlay"] as? [String:AnyObject]
                                                let subjectList = bottomOverlay!["subjectList"] as! NSArray
                                                print(subjectList)

                                                for objList in subjectList {
                                                    arrSubjectList.append(objList as! NSDictionary)

                                                }
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
    
    func callWebserviceForAskQues() {
        
//
        BaseApi.showActivityIndicator(icon: nil, text: "")
        let parameters = [
                          "question":"IOS",
                          "limit":"20",
                          "uploaded_image_question_id":"",
                          "question_text":txtTypeText.text!] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "https://api.doubtnut.com/v10/questions/ask")! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        let auth = userDef.value(forKey: "Auth_token") as! String
        request.addValue(auth, forHTTPHeaderField: "x-auth-token")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("US", forHTTPHeaderField: "country")
        request.addValue("776", forHTTPHeaderField: "version_code")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    let jsonString = BaseApi.showParam(json: json)
                    let param = BaseApi.showParam(json: parameters)
                    UtilesSwift.shared.displayAlertWithHandler(with: "Parameter: \(param),  URL:- https://api.doubtnut.com/v10/questions/ask", message: "Response: \(jsonString)     version_code:- 776", buttons: ["OK","DISSMISS"], viewobj: self) { (checkBtn) in
                        if checkBtn == "OK"{
                            
                            if let meta = json["meta"] as? [String:AnyObject]{
                                let code = meta["code"] as! Int
                                if code == 200 {
                                    // create the alert
                                    OperationQueue.main.addOperation {
                                        BaseApi.hideActivirtIndicator()
                                        
                                        if let data = json["data"] as? [String:AnyObject]{
                                            self.txtTypeText.resignFirstResponder()
                                            UIView.animate(withDuration: 1.0,
                                                              delay: 0.0,
                                                              options: [.curveEaseIn],
                                                              animations: {
                                                                self.viewTypeTextTopConstraint.constant = -200
                                                                self.view.layoutIfNeeded()
                                                              }, completion: nil)
                                            let vc = FlowController().instantiateViewController(identifier: "VIdeoListVC", storyBoard: "Home") as! VIdeoListVC
                                            vc.arrAskQuestion = data
                                            vc.questionstring = self.txtTypeText.text!

                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                                  //  }
                                }else{
                                    OperationQueue.main.addOperation {
                                        BaseApi.hideActivirtIndicator()
                                    }
                                }
                            }
                        }else{
                            BaseApi.hideActivirtIndicator()

                        }
                    }
            
                    // handle json..
                        
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
//MARK:- UITextview delegate

extension CustomCameraVC: UITextViewDelegate{
    

    func textViewDidEndEditing(_ textView: UITextView) {
        txtTypeText.resignFirstResponder()
        UIView.animate(withDuration: 1.0,
                          delay: 0.0,
                          options: [.curveEaseIn],
                          animations: {
                            self.viewTypeTextTopConstraint.constant = -200
                            self.view.layoutIfNeeded()
                          }, completion: nil)
        if txtTypeText.text == "" {
            self.showToast(message: "Please Enter Text Doubt")
        }else{
            callWebserviceForAskQues()

        }
       
//        }else{
//            print(txtTypeText.text)
//            txtTypeText.resignFirstResponder()
//
//        }
    }
        
}

//MARK:- Button Action
extension CustomCameraVC{
    @IBAction func btnTypeTextAction(_ sender: UIButton) {
        toggleTorch(on: false)
        if sender.tag == 10{
            txtTypeText.text = ""
            //close
            txtTypeText.resignFirstResponder()
            UIView.animate(withDuration: 1.0,
                              delay: 0.0,
                              options: [.curveEaseIn],
                              animations: {
                                self.viewTypeTextTopConstraint.constant = -200
                                self.view.layoutIfNeeded()
                              }, completion: nil)
        }else{
            if txtTypeText.text == "" {
                txtTypeText.resignFirstResponder()
                self.showToast(message: "Please Type your Question")
            }else{
                callWebserviceForAskQues()
            }
        }
    }
    @IBAction func btnTypeAction(_ sender: UIButton) {
        toggleTorch(on: false)
        txtTypeText.becomeFirstResponder()
        UIView.animate(withDuration: 1.0,
                          delay: 0.0,
                          options: [.curveEaseOut],
                          animations: {
                            self.viewTypeTextTopConstraint.constant = 200
                            self.view.layoutIfNeeded()
                          }, completion: nil)
    }
    @IBAction func btnGellaryAction(_ sender: UIButton) {
//        checkCameraAccess()
        toggleTorch(on: false)

        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        vc.mediaTypes = ["public.image"]
        present(vc, animated: true)

    }
    @IBAction func watchHistoryAction(_ sender: UIButton) {
        toggleTorch(on: false)
        self.view.endEditing(true)
        let vc = FlowController().instantiateViewController(identifier: "WatchHistoryViewController", storyBoard: "Profile") as! WatchHistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func btnImogAction(_ sender: UIButton) {
        toggleTorch(on: false)
        BoolValue.isFromImog = true
        let vc = FlowController().instantiateViewController(identifier: "GetAnimationVC", storyBoard: "Home") as! GetAnimationVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        toggleTorch(on: false)
        if let count = userDef.value(forKey: "count_camera") as? Int{
            
            if count > 2{
                let vc = FlowController().instantiateViewController(identifier: "DashboardVC", storyBoard: "Home") as! DashboardVC
                self.navigationController?.pushViewController(vc, animated: true)

            }
            else{
                BoolValue.isFromImog = false
                let vc = FlowController().instantiateViewController(identifier: "DoYouHaveQuestVC", storyBoard: "Home") as! DoYouHaveQuestVC
                vc.viewController = self
                vc.arrSubjectList = arrSubjectList
                self.view.addSubview(vc.view)
                self.addChild(vc)
                vc.view.layoutIfNeeded()
                
                vc.view.frame=CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                vc.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            }
        }else{
            BoolValue.isFromImog = false
            let vc = FlowController().instantiateViewController(identifier: "DoYouHaveQuestVC", storyBoard: "Home") as! DoYouHaveQuestVC
            vc.viewController = self
            vc.arrSubjectList = arrSubjectList
            self.view.addSubview(vc.view)
            self.addChild(vc)
            vc.view.layoutIfNeeded()
            
            vc.view.frame=CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            vc.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }
    }
    
    @IBAction func btnDontHaveQuesAction(_ sender: UIButton) {
        toggleTorch(on: false)
        
        callWebserviceGetDemo()
    }
    @IBAction func btnLearnHowAction(_ sender: UIButton) {
        toggleTorch(on: false)
        if sender.tag == 10 {
            viewLearnPopUp.isHidden = true
        }else{
            BoolValue.isFromImog = true
            let vc = FlowController().instantiateViewController(identifier: "DoYouHaveQuestVC", storyBoard: "Home") as! DoYouHaveQuestVC
            viewLearnPopUp.isHidden = true
            btnImogOutlet.isHidden = false
            vc.viewController = self
            vc.arrTitle = arrAnimationTitle
            self.view.addSubview(vc.view)
            self.addChild(vc)
            vc.view.layoutIfNeeded()
            
            vc.view.frame=CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            vc.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        }
    }
    @IBAction func btnClickImageAction(_ sender: UIButton) {
        viewCropImg.isHidden = false
        viewLearnPopUp.isHidden = true
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        toggleTorch(on: false)

    }
    
    
    @IBAction func btnRetakeAction(_ sender: UIButton) {
        toggleTorch(on: false)
        guard !cropView.isEdited else {
            
            let alertController = UIAlertController(title: "Warning!", message:
                                                        "All changes will be lost.", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel, handler: { _ in
                
                //    _ = self.navigationController?.popViewController(animated: true)
                self.viewImgCrop.isHidden = true
                self.viewCropOneQues.isHidden = true
                self.viewDidAppear(true)

            }))
            
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            return
        }
        if !cropView.isEdited{
            self.viewImgCrop.isHidden = true
            self.viewCropOneQues.isHidden = true
            self.viewDidAppear(true)

        }
        
    }
    
    @IBAction func btnRotateAction(_ sender: UIButton) {
        toggleTorch(on: false)
        angle += .pi/2 //M_PI_2
        cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            
            if self.angle == 2 * .pi {//M_PI
                self.angle = 0.0
            }
        })
    }
    
    @IBAction func btnFlashAction(_ sender: UIButton) {
        toggleTorch(on: false)
        if sender.isSelected{
            sender.isSelected = false
            toggleTorch(on: false)
        }else{
            sender.isSelected = true
            toggleTorch(on: true)
        }
        
    }
    @IBAction func btnFindSolutionAction(_ sender: UIButton) {
        toggleTorch(on: false)
        guard let image = cropView.croppedImage else {
            return
        }
        
//        let data = image.pngData()
//        let requestHandler = VNImageRequestHandler.init(data: data!, options: [:])
//        let request = VNRecognizeTextRequest { (request, error) in
//
//            guard let observations = request.results as? [VNRecognizedTextObservation]
//            else { return }
//
//            for observation in observations {
//
//                let topCandidate: [VNRecognizedText] = observation.topCandidates(1000)
//                let recognizedTet1: VNRecognizedText = topCandidate[0]
//                let recognizedTet2: VNRecognizedText = topCandidate[1]
//                let recognizedTet3: VNRecognizedText = topCandidate[2]
//                let recognizedTet4: VNRecognizedText = topCandidate[3]
//
//                print(recognizedTet1.string)
//                print(recognizedTet2.string)
//                print(recognizedTet3.string)
//                print(recognizedTet4.string)
//
//                if let recognizedText: VNRecognizedText = topCandidate.first {
//                    print(recognizedText.string)
//                }
//            }
//        }
//        // non-realtime asynchronous but accurate text recognition
//        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
//
//        // nearly realtime but not-accurate text recognition
//        request.recognitionLevel = VNRequestTextRecognitionLevel.fast
//
//        try? requestHandler.perform([request])
        
        
        callawebServiewForGenerateUrl(imagevw : image)
     
    }
}
extension CustomCameraVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            cropView.delegate = self
            cropView.image = selectedImage
            cropView.contentMode = .scaleAspectFit
            self.viewLearnPopUp.isHidden = true

            viewImgCrop.isHidden = false
            viewCropOneQues.isHidden = false
            cropView.showOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                //     self.overlayActionView.alpha = 1
                
            }, completion: nil)

           
        }
        
        dismiss(animated: true, completion: nil)
    }
}
