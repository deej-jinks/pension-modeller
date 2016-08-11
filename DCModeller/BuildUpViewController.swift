//
//  TestingModelViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 15/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import Charts
import CoreData

class BuildUpViewController: UIViewController {

    var activeAssumption = 0
    let cornerRadius:CGFloat = 7.5
    
    @IBOutlet weak var inflationButton: UIButton!
    @IBOutlet weak var salaryInflationButton: UIButton!
    @IBOutlet weak var investmentReturnButton: UIButton!
    @IBOutlet var assumptionButtons: [UIButton]!
    
    @IBOutlet weak var retirementFVLabel: UILabel! {
        didSet {
            retirementFVLabel.layer.cornerRadius = cornerRadius
            retirementFVLabel.clipsToBounds = true
            //retirementFVLabel.layer.borderColor = GlobalConstants.ColorPalette.SecondaryColorDark.CGColor
            //retirementFVLabel.layer.borderWidth = 1.5
            retirementFVLabel.backgroundColor = GlobalConstants.ColorPalette.SecondaryColorExtraLight
            
        }
    }
    
    var ltaBreached: Bool {
        return currentDCPension!.fundValueAtRetirementNominal > GlobalConstants.TaxLimits.LifetimeAllowance
    }
    
    var aaBreached: Bool {
        return Double(currentDCPension!.totalContributionRate!) * Double(currentUser!.salary!) > GlobalConstants.TaxLimits.AnnualAllowance
    }
    
    @IBOutlet weak var fvWarningTriangle: UIButton! {
        didSet {
            fvWarningTriangle.alpha = 0.0
            fvWarningTriangle.userInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var assumptionsSlider: UISlider!
    
    @IBOutlet weak var fundvalueChartView: CustomBarChartView!
    
    @IBOutlet weak var retirementAgeSlider: UISlider!
    @IBOutlet weak var retirementAgeLabel: UILabel!
    
    @IBOutlet weak var contributionsSlider: UISlider! {
        didSet {
            contributionsSlider.minimumValue = 0
            contributionsSlider.maximumValue = Float(GlobalConstants.ContributionRateIncrements.count) - 1.0
        }
    }
    @IBOutlet weak var contributionsLabel: UILabel!
    
    @IBOutlet var contentBoxes: [UIView]! {
        didSet {
            for box in contentBoxes {
                box.layer.cornerRadius = cornerRadius
                box.layer.shadowColor = UIColor.blackColor().CGColor
                box.layer.shadowOpacity = 0.4
                box.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialiseUI()

        do {
            try AppDelegate.getContext().save()
        } catch {}
    }
    
    override func viewWillAppear(animated: Bool) {
        initialiseUI()
    }

    func initialiseUI() {
        if currentDCPension!.selectedRetirementAge == nil {
            currentDCPension!.selectedRetirementAge = max(65,currentUser!.ageNearest)
        } else if Int(currentDCPension!.selectedRetirementAge!) < currentUser!.ageNearest {
            currentDCPension!.selectedRetirementAge = currentUser!.ageNearest
        }
        retirementAgeSlider.minimumValue = Float(max(55,currentUser!.ageNearest))
        retirementAgeSlider.value = Float(currentDCPension!.selectedRetirementAge!)
        
        //assumptionsSlider.value = Float(currentUser!.priceInflation!)
        
        
        for i in 0..<GlobalConstants.ContributionRateIncrements.count {
            if Double(currentDCPension!.totalContributionRate!) == GlobalConstants.ContributionRateIncrements[i] {
                contributionsSlider.value = Float(i)
            }
        }
        
        let dummyButton = UIButton()
        dummyButton.tag = activeAssumption
        assumptionButtonPressed(dummyButton)
        
        updateUI()

    }

    func updateUI() {
        
        let percentFormatter = createPercentageNumberFormatter()
        inflationButton.setTitle(percentFormatter.stringFromNumber(assumptionsSlider.value), forState: .Normal)
        let formatter = createNumberFormatter(maxValue: currentDCPension!.fundValueAtRetirement, prefix: "£")

        
        inflationButton.setTitle(percentFormatter.stringFromNumber(currentUser!.priceInflation!), forState: .Normal)
        salaryInflationButton.setTitle(percentFormatter.stringFromNumber(currentUser!.salaryInflation!), forState: .Normal)
        investmentReturnButton.setTitle(percentFormatter.stringFromNumber(currentDCPension!.investmentReturnsPreRetirement!), forState: .Normal)
    
        
        retirementFVLabel.text = "  Retirement Fund Value : " + formatter.stringFromNumber(currentDCPension!.fundValueAtRetirement)! + "        "
        
        if (ltaBreached || aaBreached) && fvWarningTriangle.alpha == 0.0 {
            UIView.animateWithDuration(0.5, animations: { 
                self.fvWarningTriangle.alpha = 1.0
                self.fvWarningTriangle.userInteractionEnabled = true
            })
        } else if !ltaBreached && !aaBreached && fvWarningTriangle.alpha != 0.0 {
            UIView.animateWithDuration(0.5, animations: {
                self.fvWarningTriangle.alpha = 0.0
                self.fvWarningTriangle.userInteractionEnabled = false
            })
        }
        
        retirementAgeLabel.text = String(currentDCPension!.selectedRetirementAge!)
        
        percentFormatter.maximumSignificantDigits = 2
        percentFormatter.minimumSignificantDigits = 2
        contributionsLabel.text = percentFormatter.stringFromNumber(currentDCPension!.totalContributionRate!)
        
         //print("fund values : \(currentDCPension!.preRetirementFundValues)")
        drawGraph()
    }
    
    func drawGraph() {
        fundvalueChartView.setFundvalueBarChart(labels: currentUser!.agesTo75AsStrings, values: currentDCPension!.preRetirementFundValues, maxValue: currentDCPension!.fundValueAt75, limitLine: Double(currentDCPension!.selectedRetirementAge!) - Double(currentUser!.ageNearest))
    }
    
    @IBAction func contributionsSliderValueChanged(sender: AnyObject) {
        contributionsSlider.value = Float(Int(contributionsSlider.value * 200 + 0.5)) / 200.0
        currentDCPension!.totalContributionRate = GlobalConstants.ContributionRateIncrements[Int(contributionsSlider.value)]
        updateUI()
    }
    
    @IBAction func contributionsIncrementerPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            contributionsSlider.value -= 1
            contributionsSliderValueChanged(sender)
        case 1:
            contributionsSlider.value += 1
            contributionsSliderValueChanged(sender)
        default: break
        }
    }
    
    @IBAction func retirementAgeSliderValueChanged(sender: AnyObject) {
        retirementAgeSlider.value = Float(Int(retirementAgeSlider.value + 0.5))
        currentDCPension!.selectedRetirementAge = retirementAgeSlider.value
        updateUI()
    }
    
    @IBAction func retirementAgeIncrementerPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            retirementAgeSlider.value -= 1
            retirementAgeSliderValueChanged(sender)
        case 1:
            retirementAgeSlider.value += 1
            retirementAgeSliderValueChanged(sender)
        default: break
        }
        updateUI()
    }

    @IBAction func assumptionsSliderValueChanged(sender: AnyObject) {
        assumptionsSlider.value = Float(Int(assumptionsSlider.value * 200 + 0.5)) / 200.0
        switch activeAssumption {
        case 0: currentUser!.priceInflation = Double(assumptionsSlider.value)
        case 1: currentUser!.salaryInflation = Double(assumptionsSlider.value)
        case 2: currentDCPension!.investmentReturnsPreRetirement = Double(assumptionsSlider.value)
        default: break
        }
        
        updateUI()
    }
    
    @IBAction func assumptionButtonPressed(sender: UIButton) {
        print("assumption button pressed. Screen size : \(view.frame.height) by \(view.frame.width)")
        
        activeAssumption = sender.tag
        for button in assumptionButtons {
            if button.tag == sender.tag {
                button.setBackgroundImage(UIImage(named: "orangeBall"), forState: .Normal)
                button.tintColor = GlobalConstants.ColorPalette.SecondaryColorLight
            } else {
                button.setBackgroundImage(UIImage(named: "greyBall"), forState: .Normal)
                button.tintColor = FAColors.FAGrey50
            }
        }
        
        //set slider value
        switch activeAssumption {
        case 0: assumptionsSlider.value = Float(currentUser!.priceInflation!)
        case 1: assumptionsSlider.value = Float(currentUser!.salaryInflation!)
        case 2: assumptionsSlider.value = Float(currentDCPension!.investmentReturnsPreRetirement!)
        default: break
        }
    }
    
    @IBAction func assumptionStepButtonPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            assumptionsSlider.value -= 0.005
            assumptionsSliderValueChanged(sender)
        case 1:
            assumptionsSlider.value += 0.005
            assumptionsSliderValueChanged(sender)
        default: break
        }
        updateUI()
    }
    
    @IBAction func showWarning(sender: UIButton) {
        let alert = UIAlertView()
        
        if ltaBreached {
            alert.title = "Warning: Lifetime Allowance"
            
            let formatter = createNumberFormatter(maxValue: 5000000.0, prefix: "£")
            formatter.minimumFractionDigits = 2
            alert.message = "Your projected fund value at retirement is " + formatter.stringFromNumber(Double(currentDCPension!.fundValueAtRetirementNominal))! + " (before adjusting into today's money).\n\nThis is higher than the current lifetime allowance of " + formatter.stringFromNumber(GlobalConstants.TaxLimits.LifetimeAllowance)! + ".\n\nIf the lifetime allowance remains the same (and is not indexed), you could face a penalty tax charge on the excess above the allowance."
        } else {
            alert.title = "Warning: Annual Allowance"
            
            let formatter = createNumberFormatter(maxValue: 1000.0, prefix: "£")
            alert.message = "Based on the contribution rate you have selected, your annual contributions next year would be " + formatter.stringFromNumber(Double(currentDCPension!.totalContributionRate!) * Double(currentUser!.salary!))! + ".\n\nThis is higher than the current annual allowance of " + formatter.stringFromNumber(GlobalConstants.TaxLimits.AnnualAllowance)! + " per year.\n\n If you were to pay pension contributions at this level, you could face a penalty tax charge on the excess above the allowance, depending on the extent of any allowances 'carried forward' from earlier years."
        }
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToCashOut" {
            if !annuitiesUpdated {
                repeat {
                    sleep(200)
                } while !annuitiesUpdated
            }
        }
    }

}
