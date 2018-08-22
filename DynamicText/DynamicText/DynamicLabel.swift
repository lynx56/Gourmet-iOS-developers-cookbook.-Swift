//
//  DynamicLabel.swift
//  DynamicText
//
//  Created by lynx on 22/08/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

class DynamicLabel: UILabel{
    var textStyle: UIFontTextStyle!
    var observers: [NSObjectProtocol]!
    
    override var attributedText: NSAttributedString?{
        didSet{
            
        }
    }
    
    init(withStyle textStyle: UIFontTextStyle){
        super.init(frame: CGRect.zero)
        self.textStyle = textStyle
        
        self.font = UIFont.preferredFont(forTextStyle: textStyle)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontStyle), name: Notification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    @objc func changeFontStyle(notification: NSNotification){
        self.font = UIFont.preferredFont(forTextStyle: self.textStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override convenience init(frame: CGRect) {
        self.init(withStyle: UIFontTextStyle.headline)
    }
    
    deinit {
        for o in observers{
            NotificationCenter.default.removeObserver(o)
        }
    }
    
    static func label(wuthTextStyle style: UIFontTextStyle)->DynamicLabel{
        return DynamicLabel(withStyle: style)
    }
    
}
