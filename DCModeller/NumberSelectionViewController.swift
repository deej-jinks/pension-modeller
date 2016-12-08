//
//  NumberSelectionViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 21/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import CoreData

class NumberSelectionViewController: UIViewController, UITextFieldDelegate {

    var dataTypeIndex = 0
    
    @IBOutlet weak var instructionsLabel: UILabel!

    @IBOutlet weak var entryNameLabel: UILabel!
    @IBOutlet weak var entrySuffixLabel: UILabel!
    
    @IBOutlet weak var numberTextField: UITextField! {
        didSet {
            numberTextField.delegate = self
            switch dataTypeIndex {
            case 0...99: numberTextField.keyboardType = UIKeyboardType.numberPad
            default: numberTextField.keyboardType = UIKeyboardType.default
            }
            
        }
    }
    
    let cornerRadius: CGFloat = 7.5
    @IBOutlet var contentBoxes: [UIView]! {
        didSet {
            for box in contentBoxes {
                box.layer.cornerRadius = cornerRadius
                box.layer.shadowColor = UIColor.black.cgColor
                box.layer.shadowOpacity = 0.4
                box.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialiseUI()
        numberTextField.becomeFirstResponder()

    }

    func initialiseUI() {
        switch dataTypeIndex {
        case 0:
            instructionsLabel.text = Strings.SalaryEntryInstructions
            numberTextField.text = currentUser!.salary == nil ? "" : String(Int(currentUser!.salary!))
            entryNameLabel.text = "Salary:"
            entrySuffixLabel.text = "pa"
        case 1:
            instructionsLabel.text = Strings.DCFundValueEntryInstructions
            numberTextField.text = currentDCPension!.currentFundValue == nil ? "" : String(Int(currentDCPension!.currentFundValue!))
            entryNameLabel.text = "Fund Value:"
            entrySuffixLabel.text = ""
        default: break
    }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch dataTypeIndex {
        case 0: currentUser?.salary = Double(textField.text!)! as NSNumber?
        case 1: currentDCPension?.currentFundValue = Double(textField.text!)! as NSNumber?
        default: break
        }
        
    }
}
