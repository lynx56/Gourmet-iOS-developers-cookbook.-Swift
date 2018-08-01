//
//  CameraHelper.swift
//  QRCodesReader
//
//  Created by lynx on 30/07/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import AVFoundation
import UIKit

class CameraHelper: NSObject, AVCaptureMetadataOutputObjectsDelegate{
    private var session: AVCaptureSession!
    var metadataDelegate: CameraHelperMetadataDelegate!
    
    override init() {
        super.init()
        session = AVCaptureSession()
    }
    
    static var frontCamera:AVCaptureDevice{
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTrueDepthCamera], mediaType: AVMediaType.video, position: .front)
        
        return discoverySession.devices.first!
    }
    
    static var backCamera:AVCaptureDevice{
        
      //  return AVCaptureDevice.devices(for: .video).first(where: {$0.position == AVCaptureDevice.Position.back}) ?? AVCaptureDevice.default(for: .video)!
         let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera ], mediaType: AVMediaType.video, position: .back)
         
         return discoverySession.devices.first!
    }
    
    func embedPreviewInView(_ view: inout UIView){
        if session == nil{
            return
        }
        
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = view.bounds
        preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(preview)
        // view.layer.insertSublayer(preview, at: 0)
    }
    
    func setVideoOutputScale(_ scale: CGFloat){
        self.session.beginConfiguration()
        
        for output in session.outputs{
            for connection in output.connections{
                connection.videoScaleAndCropFactor = scale
            }
        }
        
        session.commitConfiguration()
    }
    
    func startSession(){
        if session.isRunning{
            return
        }
        session.startRunning()
    }
    
    func stopSession(){
        session.stopRunning()
    }
    
    func useDevice(_ device: AVCaptureDevice){
        session.beginConfiguration()
        session.inputs.forEach { session.removeInput($0) }
        
        let captureInput = try! AVCaptureDeviceInput(device: device)
        session.addInput(captureInput)
        
        session.commitConfiguration()
    }
    
    func addMetaDataOutput(){
        session.beginConfiguration()
        session.outputs.forEach { session.removeOutput($0) }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        session.addOutput(output)
        
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        session.commitConfiguration()
    }
    
    
    
    func previewInView(_ view: UIView) -> AVCaptureVideoPreviewLayer?{
        guard let sublayers = view.layer.sublayers else {
            return nil
        }
        
        for layer in sublayers{
            if layer is AVCaptureVideoPreviewLayer{
                return layer as! AVCaptureVideoPreviewLayer
            }
        }
        
        return nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        let barcodeTypes = [AVMetadataObject.ObjectType.upce,
                            AVMetadataObject.ObjectType.code39,
                            AVMetadataObject.ObjectType.code39Mod43,
                            AVMetadataObject.ObjectType.ean13,
                            AVMetadataObject.ObjectType.ean8,
                            AVMetadataObject.ObjectType.code93,
                            AVMetadataObject.ObjectType.code128,
                            AVMetadataObject.ObjectType.pdf417,
                            AVMetadataObject.ObjectType.qr,
                            AVMetadataObject.ObjectType.aztec]
        
        for metadata in metadataObjects{
            if barcodeTypes.contains(metadata.type){
                let o = metadata as! AVMetadataMachineReadableCodeObject
                if let value = o.stringValue{
                      metadataDelegate.processBarcode(value, withType: metadata.type.rawValue, withMetadata: o)
                }
                //  if let metadataDelegate = metadataDelegate, metadataDelegate.res
            }else if metadata.type == .face{
                metadataDelegate.processFace(metadata as! AVMetadataFaceObject)
            }
        }
    }
}
            

protocol CameraHelperMetadataDelegate{
    func processBarcode(_ barcode: String, withType codeType: String, withMetadata metadata: AVMetadataMachineReadableCodeObject)
    func processFace(_ metadata: AVMetadataFaceObject)
}


