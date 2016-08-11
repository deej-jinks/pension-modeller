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
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        
            print("didSet TsCsCheckbox isChecked, newValue : \(isChecked)")
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
            currentUser!.acceptedTsCs = isChecked
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
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
