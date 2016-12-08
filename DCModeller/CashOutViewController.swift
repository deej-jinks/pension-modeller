//
//  CashOutViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 24/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit

class CashOutViewController: UIViewController {

    let cornerRadius:CGFloat = 7.5
    
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
                box.layer.shadowColor = UIColor.black.cgColor
                box.layer.shadowOpacity = 0.4
                box.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }
    
    @IBOutlet weak var annuityVCHolder: UIView!
    
    @IBOutlet weak var drawdownVCHolder: UIView! {
        didSet {
            drawdownVCHolder.alpha = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("accepted TsCs : \(currentUser!.acceptedTsCs!)")
        
        retirementAgeSlider.value = Float(currentDCPension!.selectedRetirementAge!)
        
        for i in 0..<GlobalConstants.ContributionRateIncrements.count {
            if Double(currentDCPension!.totalContributionRate!) == GlobalConstants.ContributionRateIncrements[i] {
                contributionsSlider.value = Float(i)
            }
        }
        
        
        
        initialiseUI()
        
        do {
            try AppDelegate.getContext().save()
        } catch {}
    }
    
    func initialiseUI() {
        if currentDCPension!.selectedRetirementAge == nil {
            currentDCPension!.selectedRetirementAge = max(65,currentUser!.ageNearest)
        } else if Int(currentDCPension!.selectedRetirementAge!) < currentUser!.ageNearest {
            currentDCPension!.selectedRetirementAge = currentUser!.ageNearest as NSNumber?
        }
        retirementAgeSlider.minimumValue = Float(max(55,currentUser!.ageNearest))
        retirementAgeSlider.value = Float(currentDCPension!.selectedRetirementAge!)
        
        for i in 0..<GlobalConstants.ContributionRateIncrements.count {
            if Double(currentDCPension!.totalContributionRate!) == GlobalConstants.ContributionRateIncrements[i] {
                contributionsSlider.value = Float(i)
            }
        }
        
//        let dummyButton = UIButton()
//        dummyButton.tag = activeAssumption
//        assumptionButtonPressed(dummyButton)
        
        updateUI()
        
    }
    
    func updateUI() {
        let percentFormatter = createPercentageNumberFormatter()
//        let formatter = createNumberFormatter(maxValue: currentDCPension!.fundValueAtRetirement, prefix: "£")
        
        retirementAgeLabel.text = String(describing: currentDCPension!.selectedRetirementAge!)
        
        percentFormatter.maximumSignificantDigits = 2
        percentFormatter.minimumSignificantDigits = 2
        contributionsLabel.text = percentFormatter.string(from: currentDCPension!.totalContributionRate!)
        
        annuityViewController!.updateUI()
        drawdownViewController!.updateUI()
        //print("fund values : \(currentDCPension!.preRetirementFundValues)")
    }
    
    @IBAction func contributionsSliderValueChanged(_ sender: AnyObject) {
        contributionsSlider.value = Float(Int(contributionsSlider.value * 200 + 0.5)) / 200.0
        currentDCPension!.totalContributionRate = GlobalConstants.ContributionRateIncrements[Int(contributionsSlider.value)] as NSNumber?
        updateUI()
    }
    
    @IBAction func contributionsIncrementerPressed(_ sender: UIButton) {
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
    
    @IBAction func retirementAgeSliderValueChanged(_ sender: AnyObject) {
        retirementAgeSlider.value = Float(Int(retirementAgeSlider.value + 0.5))
        currentDCPension!.selectedRetirementAge = retirementAgeSlider.value as NSNumber?
        updateUI()
    }
    
    @IBAction func retirementAgeIncrementerPressed(_ sender: UIButton) {
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
    
    @IBAction func tabChanged(_ sender: UISegmentedControl) {
        
        let dummyButton = UIButton()
        dummyButton.tag = 0

        switch sender.selectedSegmentIndex {
        case 0:
            annuityViewController!.assumptionButtonPressed(dummyButton)
            UIView.animate(withDuration: 0.5, animations: { 
                self.annuityVCHolder.alpha = 1.0
                self.drawdownVCHolder.alpha = 0.0
            })
        case 1:
            drawdownViewController!.assumptionButtonPressed(dummyButton)
            UIView.animate(withDuration: 0.5, animations: {
                self.annuityVCHolder.alpha = 0.0
                self.drawdownVCHolder.alpha = 1.0
            })
        default: break
        }
        updateUI()
    }
    
    var annuityViewController: AnnuityViewController?
    var drawdownViewController: DrawdownViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedAnnuityVC" {
            annuityViewController = segue.destination as? AnnuityViewController
        }
        if segue.identifier == "embedDrawdownVC" {
            drawdownViewController = segue.destination as? DrawdownViewController
        }
    }
    
}
