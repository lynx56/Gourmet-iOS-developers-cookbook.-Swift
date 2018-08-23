//
//  FontHelper.swift
//  DynamicText
//
//  Created by lynx on 22/08/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit
import Foundation

extension UIFont{
    
    static var headline: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    }
    
    static var subheadline: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
    }
    
    static var body: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
    
    static var footnote: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
    }
    
    static var caption1: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
    }
    
    static var caption2: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
    }
    
    static var title1: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    }
    
    static var title2: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
    }
    
    static var title3: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3)
    }
    
    static var callout: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)
    }
    
    static var largeTitle: UIFont{
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.largeTitle)
    }
    
    static var fonts: [UIFont]{
        return [UIFont.headline, UIFont.subheadline, UIFont.body, UIFont.footnote, UIFont.caption1, UIFont.caption2, UIFont.title1, UIFont.title2, UIFont.title3, UIFont.callout, UIFont.largeTitle]
    }
    
    static var styles: [UIFontTextStyle]{
        return [UIFontTextStyle.headline, UIFontTextStyle.subheadline, UIFontTextStyle.body, UIFontTextStyle.footnote, UIFontTextStyle.caption1, UIFontTextStyle.caption2, UIFontTextStyle.title1, UIFontTextStyle.title2, UIFontTextStyle.title3, UIFontTextStyle.callout, UIFontTextStyle.largeTitle]
    }
}

/*
 | Style        | Font               | Size |
 | ------------ | ------------------ | ---- |
 | .largeTitle  | SFUIDisplay       | 34.0 |
 | .title1      | SFUIDisplay <br> (-Light on iOS <=10) | 28.0 |
 | .title2      | SFUIDisplay       | 22.0 |
 | .title3      | SFUIDisplay       | 20.0 |
 | .headline    | SFUIText-Semibold | 17.0 |
 | .callout     | SFUIText          | 16.0 |
 | .subheadline | SFUIText          | 15.0 |
 | .body        | SFUIText          | 17.0 |
 | .footnote    | SFUIText          | 13.0 |
 | .caption1    | SFUIText          | 12.0 |
 | .caption2    | SFUIText          | 11.0 |
 */


extension UIFont{
    func closestSystemStyle()->UIFontTextStyle{
        var minimumdistance = MAXFLOAT
        var selectedIndex = -1
        var index = 0
        
        for candidate in UIFont.fonts{
            let distance: Float = Float(abs(self.pointSize - candidate.pointSize))
    
            if distance < minimumdistance{
                minimumdistance = distance
                selectedIndex = index
            }
            
            index += 1
        }
        
        return UIFont.styles[selectedIndex]
    }
}

extension NSAttributedString{
    func textStyleRangeDictionary(){
        var result: [NSRange: FindedFont] = [:]
        
        self.enumerateAttributes(in: NSMakeRange(0, self.length), options: .init(rawValue: 0)) { (attrs, range, stop) in
            if let font = attrs[NSAttributedStringKey.font] as? UIFont{
                if let index = UIFont.fonts.index(of: font){
                    let textStyle = UIFont.styles[index]
                    result[range] = FindedFont.system(withStyle: textStyle)
                  //  NSValue.init(range: range) =
                }else{
                    let closestMatch = font.closestSystemStyle()
                    let closestSystemFont = UIFont.preferredFont(forTextStyle: closestMatch)
                    
                    let multiplier = font.pointSize / closestSystemFont.pointSize
                    result[range] = FindedFont.closest(closestMatch: closestMatch, fontName: font.fontName, multiplier: multiplier)
                }
            }
        }
    }
}


enum FindedFont{
    case system(withStyle: UIFontTextStyle)
    case closest(closestMatch: UIFontTextStyle, fontName: String, multiplier: CGFloat)
}
