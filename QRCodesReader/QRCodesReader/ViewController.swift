//
//  ViewController.swift
//  QRCodesReader
//
//  Created by lynx on 30/07/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, CameraHelperMetadataDelegate{
    var cameraHelper: CameraHelper!
    @IBOutlet weak var previewView: UIView!
    
    var overlay: UIView!
    var timeToDie: Date?
    var overlayChecker: CADisplayLink!
    var barcode: String?{
        didSet{
           self.navigationItem.title = barcode
        }
    }
    var image: UIImage?
    
    var speechHelper: SpeachHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlay = UIView()
        self.view.addSubview(overlay)
        overlay.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        overlayChecker = CADisplayLink(target: self, selector: #selector(checkOverlay))
        overlayChecker.add(to: RunLoop.main, forMode: .commonModes)
        speechHelper = SpeachHelper()
        speechHelper?.rate = 0.4
        speechHelper?.languageCode = Settings()
        
        Settings()
        
        tapOnTop = UITapGestureRecognizer(target: self, action: #selector(openDetails))
    }
    
    var tapOnTop: UITapGestureRecognizer?
    override func viewWillDisappear(_ animated: Bool) {
        if let gesture = tapOnTop{
            self.navigationController?.navigationBar.removeGestureRecognizer(gesture)
        }
        
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let gesture = tapOnTop{
            self.navigationController?.navigationBar.addGestureRecognizer(gesture)
        }
    }
    
    @objc func openDetails(_ sender: Any){
        performSegue(withIdentifier: "showBarcodeDetails", sender: self)
    }
    
    @objc func checkOverlay(sender: CADisplayLink){
        if overlay.frame == CGRect.zero || timeToDie == nil || timeToDie!.timeIntervalSince(Date()) > 0{
            return
        }
        
        timeToDie = nil
        overlay.frame = CGRect.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraHelper = CameraHelper()
        cameraHelper.useDevice(CameraHelper.backCamera)
        cameraHelper.startSession()
        
        cameraHelper.embedPreviewInView(&previewView!)
        cameraHelper.setVideoOutputScale(1.5)
        cameraHelper.metadataDelegate = self
        cameraHelper.addMetaDataOutput()
        cameraHelper.addVideoOutput()
        previewView.setNeedsLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func containsNumbers(string: String)->Bool{
        let nonNumericSet = CharacterSet.decimalDigits.inverted
        
        return string.rangeOfCharacter(from: nonNumericSet) == nil
    }
    
    func screenShotMethod()->UIImage?{
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
    func processBarcode(_ barcode: String, withType codeType: String, withMetadata metadata: AVMetadataMachineReadableCodeObject){
        if self.barcode != barcode{
            
            self.barcode = barcode
           
            self.cameraHelper.stopSession()
            
            if self.containsNumbers(string: barcode){
                speechHelper?.speakString(String(barcode.compactMap{String($0)}.joined(separator: " ")),withCompletion: {})
            }else{
                speechHelper?.speakString(barcode, withCompletion: {})
            }
            
            self.image = cameraHelper.outputImage
            
            
            let layer = cameraHelper.previewInView(previewView)
            
            let codeObject = layer?.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
            overlay.frame = self.view.convert(codeObject.bounds, to: previewView)
            
            timeToDie = Date(timeIntervalSinceNow: 2.0)
            
            let alert = UIAlertController(title: "Код", message: barcode, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Подробнее", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "showBarcodeDetails", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Продолжить", style: .cancel, handler: { (action) in
                self.cameraHelper.startSession()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func processFace(_ metadata: AVMetadataFaceObject) {
        try? speechHelper?.speakString("Вместо кода обнаружена рожа", languageCode: "ru_ru", withCompletion: {})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBarcodeDetails", let barcode = self.barcode{
            let controller = segue.destination.content as! BarcodeDetailsViewController
            
            controller.model = BarcodeDetailsViewController.Model(barcode: barcode, image: image)
        }
    }
}

extension UIViewController{
    var content: UIViewController{
        get{
            if let navigationController = self as? UINavigationController{
                return navigationController.topViewController!
            }else{
                return self
            }
        }
    }
}


