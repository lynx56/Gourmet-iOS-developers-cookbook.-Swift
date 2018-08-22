//
//  GeneratorViewController.swift
//  QRCodesReader
//
//  Created by lynx on 08/08/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class GeneratorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var barcodeTypeLabel: UILabel!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var picker: UIPickerView!
    let barcodeHelper = BarcodeHelper()
    var barcodesTypes: [(title: String, type: BarcodeHelper.SupportedFormat)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcodeTypeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicker)))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePicker)))
        
        self.picker.isHidden = true
        
        for type in BarcodeHelper.SupportedFormat.all(){
            var title: String = ""
            switch type{
            case .aztec:
                title = "Aztec Code"
            case .code128:
                title = "CODE 128"
            case .pdf417:
                title = "PDF 417"
            case .qr:
                title = "QR Code"
            }
            barcodesTypes.append((title: title, type: type))
        }
        
        picker.selectRow(3, inComponent: 0, animated: false)
        barcodeTypeLabel.text = barcodesTypes[3].title
        barcodeTypeLabel.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    
    @objc func showPicker(_ gesture: UITapGestureRecognizer){
        if gesture.state == .ended{
            self.picker.isHidden = false
        }
    }
    
    @objc func hidePicker(_ gesture: UITapGestureRecognizer){
        if gesture.state == .ended{
            self.picker.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return barcodesTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return barcodesTypes[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        barcodeTypeLabel.text = barcodesTypes[row].title
        self.picker.isHidden = true
    }
    
    @IBAction func generateCode(_ sender: Any) {
        let row = picker.selectedRow(inComponent: 0)
        
        if let code = barcodeHelper.generateCode(for: self.inputText.text, type: barcodesTypes[row].type){
            
            generatedBarcode = barcodeHelper.resizeImageWithoutInterpolation(code, size: CGSize(width: 300, height: 300))
            
            performSegue(withIdentifier: "showGeneratedBarcode", sender: self)
        }else{
            let alert = UIAlertController(title: "", message: "Не удалось сгенерировать код. Попробуйте еще раз", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    var generatedBarcode: UIImage?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGeneratedBarcode"{
            let controller = segue.destination.content as! BarcodeDetailsViewController
            
            controller.model = BarcodeDetailsViewController.Model(barcode: "", image: generatedBarcode)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
