//
//  CheckBox.swift
//  DCModeller
//
//  Created by Daniel Jinks on 19/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import CoreData

class TsCsCheckBox: UIButton {
    
    // Images
    let checkedImage = UIImage(named: "checkedCheckbox")! as UIImage
    let uncheckedImage = UIImage(named: "uncheckedCheckbox")! as UIImage
    
    // Bool property
    var isChecked = Bool(currentUser!.acceptedTsCs!)  {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState())
            } else {
                self.setImage(uncheckedImage, for: UIControlState())
            }
        
            print("didSet TsCsCheckbox isChecked, newValue : \(isChecked)")
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(_ sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
            currentUser!.acceptedTsCs = isChecked as NSNumber?
        }
    }

}

class CheckBox: UIButton {

    // Images
    let checkedImage = UIImage(named: "checkedCheckbox")! as UIImage
    let uncheckedImage = UIImage(named: "uncheckedCheckbox")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState())
            } else {
                self.setImage(uncheckedImage, for: UIControlState())
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(_ sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
