//
//  BarcodeDetailsViewController.swift
//  QRCodesReader
//
//  Created by lynx on 31/07/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class BarcodeDetailsViewController: UIViewController {
    struct Model{
        var barcode: String = ""
        var image: UIImage?
    }
    
    var model: Model!{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var barcodeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    @IBAction func share(_ sender: Any) {
        if let image = model.image{
        let shareController = UIActivityViewController(activityItems: [image, model.barcode], applicationActivities: nil)
             self.present(shareController, animated: true, completion: nil)
        }
    }
    
    func updateUI(){
        barcodeText?.text = model.barcode
        barcodeText?.sizeToFit()
        barcodeImage?.image = model.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
