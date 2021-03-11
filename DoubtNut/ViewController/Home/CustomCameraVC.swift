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

class CustomCameraVC: UIViewController, AVCapturePhotoCaptureDelegate  {

    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewImgCrop: UIView!
    @IBOutlet weak var viewCropImg: AKImageCropperView!
    private var cropViewProgrammatically: AKImageCropperView!
    @IBOutlet weak var imgFlash: UIImageView!
   
    @IBOutlet weak var viewCropOneQues: UIView!
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //  MARK: - Properties
   
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var flash: AVCaptureDevice.FlashMode = .off
    
   // var image: UIImage!
   
    private var cropView: AKImageCropperView {
        return cropViewProgrammatically ?? viewCropImg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewImgCrop.isHidden = true
        viewCropOneQues.isHidden = true
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
//        imgView.image = image
        cropView.delegate = self
        cropView.image = image
        cropView.contentMode = .scaleToFill
        
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
        
    }
    var angle: Double = 0.0

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
