//
//  CustomCameraVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 09/03/21.
//

import UIKit
import CameraManager

class CustomCameraVC: UIViewController {
 
    let cameraManager = CameraManager()

    @IBOutlet weak var imgFlash: UIImageView!
    // MARK: - Constants
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnImgClick: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCameraManager()
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.askUserForCameraPermission { permissionGranted in
            
            if permissionGranted {
               // self.askForPermissionsLabel.isHidden = true
               // self.askForPermissionsLabel.alpha = 0
                self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        if currentCameraState == .notDetermined {
        } else if currentCameraState == .ready {
            addCameraToView()
        } else {
        }
        
        if cameraManager.hasFlash {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeFlashMode))
            imgFlash.addGestureRecognizer(tapGesture)
        }
        
        cameraManager.cameraOutputMode = CameraOutputMode.stillImage
        switch cameraManager.cameraOutputMode {
            case .stillImage:
                print("Image")
            case .videoWithMic, .videoOnly:
                print("Video")
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
        cameraManager.startQRCodeDetection { result in
            switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopQRCodeDetection()
        cameraManager.stopCaptureSession()
    }
    
    // MARK: - ViewController
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = true
        
        cameraManager.writeFilesToPhoneLibrary = false
        
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
    }
    
    
    fileprivate func addCameraToView() {
        cameraManager.addPreviewLayerToView(viewCamera, newCameraOutputMode: CameraOutputMode.videoWithMic)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) -> Void in }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnImgClickAction(_ sender: UIButton) {
        switch cameraManager.cameraOutputMode {
            case .stillImage:
                cameraManager.capturePictureWithCompletion { result in
                    switch result {
                        case .failure:
                            self.cameraManager.showErrorBlock("Error occurred", "Cannot save picture.")
                        case .success(let content):
//
//                            let vc: ImageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController
//                            if let validVC: ImageViewController = vc,
//                                case let capturedData = content.asData {
//                                print(capturedData!.printExifData())
//                                let capturedImage = UIImage(data: capturedData!)!
//                                validVC.image = capturedImage
//                                validVC.cameraManager = self.cameraManager
//                                self.navigationController?.pushViewController(validVC, animated: true)
//                            }
                            print(content.asData)
                    }
                }
            case .videoWithMic, .videoOnly:
              //  cameraButton.isSelected = !cameraButton.isSelected
              //  cameraButton.setTitle("", for: UIControl.State.selected)
                
              //  cameraButton.backgroundColor = cameraButton.isSelected ? redColor : lightBlue
                if sender.isSelected {
                    cameraManager.startRecordingVideo()
                } else {
                    cameraManager.stopVideoRecording { (_, error) -> Void in
                        if error != nil {
                            self.cameraManager.showErrorBlock("Error occurred", "Cannot save video.")
                        }
                    }
                }
        }
    }
    
    @IBAction func btnFlashAction(_ sender: UIButton) {
        
    }
    
    // MARK: - @IBActions
    
    @IBAction func changeFlashMode(_ sender: UIButton) {
        switch cameraManager.changeFlashMode() {
            case .off:
                imgFlash.image = UIImage(named: "Group 309")
            case .on:
                imgFlash.image = UIImage(named: "Group 309")
            case .auto:
                imgFlash.image = UIImage(named: "Group 309")
        }
    }

}
public extension Data {
    func printExifData() {
        let cfdata: CFData = self as CFData
        let imageSourceRef = CGImageSourceCreateWithData(cfdata, nil)
        let imageProperties = CGImageSourceCopyMetadataAtIndex(imageSourceRef!, 0, nil)!
        
        let mutableMetadata = CGImageMetadataCreateMutableCopy(imageProperties)!
        
        CGImageMetadataEnumerateTagsUsingBlock(mutableMetadata, nil, nil) { _, tag in
            print(CGImageMetadataTagCopyName(tag)!, ":", CGImageMetadataTagCopyValue(tag)!)
            return true
        }
    }
}
