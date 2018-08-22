//
//  BarcodeHelper.swift
//  QRCodesReader
//
//  Created by lynx on 31/07/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeHelper{
    enum SupportedFormat: String {
        case code128 = "CICode128BarcodeGenerator"
        case pdf417 = "CIPDF417BarcodeGenerator"
        case aztec = "CIAztecCodeGenerator"
        case qr = "CIQRCodeGenerator"
        
        static func all() -> [SupportedFormat]{
            return [code128, pdf417, aztec, qr]
        }
    }
    
     func generateCode(for string: String, type: SupportedFormat, size: CGSize)->UIImage?{
        let helper = BarcodeHelper()
        if let generatedCode = helper.generateCode(for: string, type: type){
            return helper.resizeImageWithoutInterpolation(generatedCode, size: size)
        }
        
        return nil
    }
    
    func image(fromCiImage image: CIImage)->UIImage?{
        let imageRef = CIContext(options: nil).createCGImage(image, from: image.extent)
        let image = UIImage(cgImage: imageRef!, scale: 1, orientation: .down)
        
        
        return image
    }
    
    func generateCode(for string: String, type: SupportedFormat)->UIImage?{
        guard let data = string.data(using: String.Encoding.utf8)
            else { NSLog("Could not extract data from string"); return nil }
        
        var parameters: [String: Any] = ["inputMessage" : data]
        switch type {
        case .aztec:
            parameters["inputCorrectionLevel"] = 25
        case .qr:
            parameters["inputCorrectionLevel"] = "H"
        case .pdf417:
            parameters["inputCorrectionLevel"] = 3
        case .code128:
            parameters["inputCorrectionLevel"] = 3
        }
        
        if let qrFilter = CIFilter(name: type.rawValue, withInputParameters: parameters){
            if let ciImage = qrFilter.outputImage{
                // return UIImage(ciImage: ciImage)
                return self.image(fromCiImage: ciImage)
            }else{
                NSLog("Filter output is empty")
            }
        }else{
            NSLog("Could not load filter")
        }
        
        return nil
    }
    
    func resizeImageWithoutInterpolation(_ source: UIImage, size: CGSize)->UIImage?{
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIGraphicsGetCurrentContext()?.interpolationQuality = CGInterpolationQuality.none
        source.draw(in: CGRect(origin: .zero, size: size))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        return result
    }
}
