//
//  FontResizing.swift
//  DCModeller
//
//  Created by Daniel Jinks on 18/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit

class constrainedLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.preferredMaxLayoutWidth = self.frame.width
    }
    
}

public func getFontScalingForScreenSize() -> CGFloat {
    var sizeScale: CGFloat = 1
    let height = max(UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width)
    switch height {
    //iPhone 4 or smaller
    case 0.0 ..< 500.0: sizeScale = 0.75
    //iPhone 5, or iPhone 6 in zoom
    case 500.0 ..< 600.0: sizeScale = 0.85
    //iPhone 6, or iPhone 6 Plus in zoom
    case 600.0 ..< 700.0: sizeScale = 1.0
    //iPhone 6 Plus
    case 700.0 ..< 800.0: sizeScale = 1.05
    //iPads
    case 800.0 ..< 10000.0: sizeScale = 1.2
    default: sizeScale = 1.0
    }
    return sizeScale
}

// replaced with a different function to capture zoomed screens
public func getFontScalingForScreenSizeNotUsed() -> CGFloat {
    
    var sizeScale: CGFloat = 1
    if let screen = UIDevice.currentDevice().screenType {
        switch screen {
        case "iPhone4":
            sizeScale = 0.75
        case "iPhone5":
            sizeScale = 0.85
        case "iPhone6":
            sizeScale = 1.0
        case "iPhone6Plus":
            sizeScale = 1.05
            
        default:
            sizeScale = 1.0
        }
    } else {
        sizeScale = 1.0
    }
    return sizeScale
}

extension UILabel {
    
    @IBInspectable
    var adjustFontToRealIPhoneSize: Bool {
        set {
            if newValue {
                let currentFont = self.font
                self.font = currentFont.fontWithSize(currentFont.pointSize * getFontScalingForScreenSize())
            }
        }
        
        get {
            return false
        }
    }
}

extension UIButton {
    @IBInspectable
    var adjustFontToRealIPhoneSize: Bool {
        set {
            if let label = self.titleLabel {
                label.adjustFontToRealIPhoneSize = true
            }
        }
        get {
            return false
        }
    }
}

extension UITextView {
    
    @IBInspectable
    var adjustFontToRealIPhoneSize: Bool {
        set {
            if newValue {
                let currentFont = self.font
                self.font = currentFont?.fontWithSize((currentFont?.pointSize)! * getFontScalingForScreenSize())
            }
        }
        
        get {
            return false
        }
    }
}

extension UITextField {
    
    @IBInspectable
    var adjustFontToRealIPhoneSize: Bool {
        set {
            if newValue {
                let currentFont = self.font
                self.font = currentFont?.fontWithSize((currentFont?.pointSize)! * getFontScalingForScreenSize())
            }
        }
        
        get {
            return false
        }
    }
}


public extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .Phone
    }
    
    var screenType: String? {
        guard iPhone else { return nil }
        switch UIScreen.mainScreen().nativeBounds.height {
        case 960:
            return "iPhone4"
        case 1136:
            return "iPhone5"
        case 1334:
            return "iPhone6"
        case 1920, 2208: //1920 on device, 2208 on simulator
            return "iPhone6Plus"
        default:
            return nil
        }
    }
}