//
//  CustomCameraVC.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 09/03/21.
//

//import CameraManager
import CoreLocation
import UIKit

class CustomCameraVC: UIViewController {
   
    // MARK: - Constants
    
    let cameraManager = CameraManager()
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnImgClick: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
setupCameraManager()
        // Do any additional setup after loading the view.
    }
    // MARK: - ViewController
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = true
        
        cameraManager.writeFilesToPhoneLibrary = false
        
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
        
        cameraManager.askUserForCameraPermission { permissionGranted in
            
            if permissionGranted {

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
        }
        
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
          
                cameraManager.capturePictureWithCompletion { result in
                    switch result {
                        case .failure:
                            self.cameraManager.showErrorBlock("Error occurred", "Cannot save picture.")
                        case .success(let content):
                            print(content.asData!)
                         //   let vc: ImageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController
                        //if let validVC: ImageViewController = vc,
//                                case let capturedData = content.asData {
//                                print(capturedData!.printExifData())
//                                let capturedImage = UIImage(data: capturedData!)!
//                                validVC.image = capturedImage
//                                validVC.cameraManager = self.cameraManager
//                                self.navigationController?.pushViewController(validVC, animated: true)
//                            }
                    }
                }
    }
    
    @IBAction func btnFlashAction(_ sender: UIButton) {
    }
    
  

}
