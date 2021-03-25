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
    
    @IBOutlet weak var viewDontHave: UIView!
    @IBOutlet weak var viewDontHaveHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblOnlyCropOneQues: UILabel!
    
  
 
    
    
    //  MARK: - Properties
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var flash: AVCaptureDevice.FlashMode = .off
    var CountIndex = 0
    var angle: Double = 0.0
    
    // var image: UIImage!
    
    private var cropView: AKImageCropperView {
        return cropViewProgrammatically ?? viewCropImg
    }
    
    var arrAnimationTitle = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callWebserviceGetAnimation()
        // Do any additional setup after loading the view.
        viewImgCrop.isHidden = true
        viewCropOneQues.isHidden = true
        viewLearnPopUp.isHidden = true
        btnImogOutlet.isHidden  = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if BoolValue.isFromDoyouhaveQues{
            BoolValue.isFromDoyouhaveQues = false
            callWebserviceGetDemo()
        }
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
        
        
        if cropView.isOverlayViewActive {
            
            cropView.hideOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                //    self.overlayActionView.alpha = 0
                
            }, completion: nil)
            
        } else {
            
            cropView.showOverlayView(animationDuration: 0.3)
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                //     self.overlayActionView.alpha = 1
                
            }, completion: nil)
            
        }
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
                                                    
                                                    
                                                    if self.cropView.isOverlayViewActive {
                                                        
                                                        self.cropView.hideOverlayView(animationDuration: 0.3)
                                                        
                                                        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                                                            //    self.overlayActionView.alpha = 0
                                                            
                                                        }, completion: nil)
                                                        
                                                    } else {
                                                        
                                                        self.cropView.showOverlayView(animationDuration: 0.3)
                                                        
                                                        UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                                                            //     self.overlayActionView.alpha = 1
                                                            
                                                        }, completion: nil)
                                                        
                                                    }

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
    
    
    @objc func update() {
        
        if CountIndex > arrAnimationTitle.count-1{
            CountIndex = 0
        }
        
        let obj = arrAnimationTitle[CountIndex]
        lblLernText.text = obj["title"] as? String
        self.CountIndex += 1
        
    }
}

//MARK:- Button Action
extension CustomCameraVC{
    @IBAction func watchHistoryAction(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "WatchHistoryViewController", storyBoard: "Profile") as! WatchHistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func btnImogAction(_ sender: UIButton) {
        BoolValue.isFromImog = true
        let vc = FlowController().instantiateViewController(identifier: "DoYouHaveQuestVC", storyBoard: "Home") as! DoYouHaveQuestVC
        vc.viewController = self
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.view.layoutIfNeeded()
        
        vc.view.frame=CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        vc.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
       
        BoolValue.isFromImog = false
        let vc = FlowController().instantiateViewController(identifier: "DoYouHaveQuestVC", storyBoard: "Home") as! DoYouHaveQuestVC
        vc.viewController = self
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.view.layoutIfNeeded()
        
        vc.view.frame=CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        vc.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
    }
    
    @IBAction func btnDontHaveQuesAction(_ sender: UIButton) {
        callWebserviceGetDemo()
    }
    @IBAction func btnLearnHowAction(_ sender: UIButton) {
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
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    
    @IBAction func btnRetakeAction(_ sender: UIButton) {
        
        guard !cropView.isEdited else {
            
            let alertController = UIAlertController(title: "Warning!", message:
                                                        "All changes will be lost.", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel, handler: { _ in
                
                //    _ = self.navigationController?.popViewController(animated: true)
                self.viewImgCrop.isHidden = true
                self.viewCropOneQues.isHidden = true
                
            }))
            
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            return
        }
        if !cropView.isEdited{
            self.viewImgCrop.isHidden = true
            self.viewCropOneQues.isHidden = true

        }
        
    }
    
    @IBAction func btnRotateAction(_ sender: UIButton) {
        
        angle += .pi/2 //M_PI_2
        cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            
            if self.angle == 2 * .pi {//M_PI
                self.angle = 0.0
            }
        })
    }
    
    @IBAction func btnFlashAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            toggleTorch(on: false)
        }else{
            sender.isSelected = true
            toggleTorch(on: true)
        }
        
    }
    @IBAction func btnFindSolutionAction(_ sender: UIButton) {
        
        guard let image = cropView.croppedImage else {
            return
        }
        
        let data = image.pngData()
        let requestHandler = VNImageRequestHandler.init(data: data!, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            
            guard let observations = request.results as? [VNRecognizedTextObservation]
            else { return }
            
            for observation in observations {
                
                let topCandidate: [VNRecognizedText] = observation.topCandidates(1000)
                let recognizedTet1: VNRecognizedText = topCandidate[0]
                let recognizedTet2: VNRecognizedText = topCandidate[1]
                let recognizedTet3: VNRecognizedText = topCandidate[2]
                let recognizedTet4: VNRecognizedText = topCandidate[3]
                
                print(recognizedTet1.string)
                print(recognizedTet2.string)
                print(recognizedTet3.string)
                print(recognizedTet4.string)
                
                if let recognizedText: VNRecognizedText = topCandidate.first {
                    print(recognizedText.string)
                }
            }
        }
        // non-realtime asynchronous but accurate text recognition
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        
        // nearly realtime but not-accurate text recognition
        request.recognitionLevel = VNRequestTextRecognitionLevel.fast
        
        try? requestHandler.perform([request])
        
        let vc = FlowController().instantiateViewController(identifier: "FindNewSolutionGifVC", storyBoard: "Home")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
