//
//  ViewController.swift
//  DynamicText
//
//  Created by lynx on 22/08/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureStackView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func configureStackView(){
        let titleLabel = DynamicLabel(withStyle: .title1)
        titleLabel.text = "Headline"
        let subTitleLabel = DynamicLabel(withStyle: .body)
        subTitleLabel.text = "Body"
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        
        let margins = view.layoutMarginsGuide
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraintEqualToSystemSpacingAfter(margins.leadingAnchor, multiplier: 1).isActive = true
        stackView.trailingAnchor.constraintEqualToSystemSpacingAfter(margins.trailingAnchor, multiplier: 1).isActive = true
        stackView.topAnchor.constraintEqualToSystemSpacingBelow(margins.topAnchor, multiplier: 1).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

