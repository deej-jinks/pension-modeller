//
//  AboutYouViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 20/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import CoreData

class AboutYouViewController: UIViewController,  UITableViewDelegate {

    
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var fundValueLabel: UILabel!
    @IBOutlet weak var contributionRateLabel: UILabel!
    
    @IBOutlet weak var acceptTCs: TsCsCheckBox!
    
    let cornerRadius: CGFloat = 7.5
    @IBOutlet var boxesToRound: [UIView]! {
        didSet {
            for box in boxesToRound {
                box.layer.cornerRadius = cornerRadius

                box.layer.shadowColor = UIColor.blackColor().CGColor
                box.layer.shadowOpacity = 0.4
                box.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }
    
    @IBOutlet var subBoxesToRound: [UIView]! {
        didSet {
            for box in boxesToRound {
                box.layer.cornerRadius = cornerRadius
            }
        }
    }

    @IBOutlet var labelsToColor: [UILabel]! {
        didSet {
            for label in labelsToColor {
                label.textColor = GlobalConstants.ColorPalette.SecondaryColorDark
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        acceptTCs.isChecked = Bool(currentUser!.acceptedTsCs!)

        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("in about you, user : \(currentUser!)")

        updateUI()
    }
    
    func updateUI() {
        
        if let dob = currentUser!.dateOfBirth {
            dateOfBirthLabel.text = getStringForDate(dob)
        } else {
            dateOfBirthLabel.text = "not set"
        }
        
        if let male = currentUser!.isMale {
            if Bool(male) {
                genderLabel.text = "Male"
            } else {
                genderLabel.text = "Female"
            }
        } else {
            genderLabel.text = "not set"
        }
        
        let formatter = createNumberFormatter(maxValue: 1000.0, prefix: "£")
        
        if let currentFV = currentDCPension!.currentFundValue {
            fundValueLabel.text = formatter.stringFromNumber(Double(currentFV))
        } else {
            fundValueLabel.text = "not set"
        }
        
        formatter.positiveSuffix = " pa"
        
        if let sal = currentUser!.salary {
            salaryLabel.text = formatter.stringFromNumber(Double(sal))
        } else {
        salaryLabel.text = "not set"
        }
        
        let percentFormatter = createPercentageNumberFormatter()
        
        if let rate = currentDCPension!.totalContributionRate {
            contributionRateLabel.text = percentFormatter.stringFromNumber(Double(rate))
        } else {
        contributionRateLabel.text = "not set"
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        print("in should perform segue...identifier : \(identifier)")
        if identifier != "Submit Data" {
            print("identifier fail")
            return true
        }
        if !acceptTCs.isChecked || currentUser!.dateOfBirth == nil || currentUser!.isMale == nil || currentUser!.salary == nil || currentDCPension!.currentFundValue == nil || currentDCPension!.totalContributionRate == nil {
            
            let alert = UIAlertView()
            alert.title = "Incomplete data"
            alert.message = "Please ensure all fields are completed, and that you have accepted the terms and conditions"
            alert.addButtonWithTitle("OK")
            alert.show()
            
            return false
        } else {
//            currentUser!.acceptedTsCs = true
            return true
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let nsvc = segue.destinationViewController as? NumberSelectionViewController {
            nsvc.dataTypeIndex = sender!.tag
        }

        
        AppDelegate.getDelegate().saveContext()
    }


}
