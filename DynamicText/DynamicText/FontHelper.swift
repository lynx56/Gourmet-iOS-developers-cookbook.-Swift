//
//  FontHelper.swift
//  DynamicText
//
//  Created by lynx on 22/08/2018.
//  Copyright © 2018 Gulnaz. All rights reserved.
//

import UIKit

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

