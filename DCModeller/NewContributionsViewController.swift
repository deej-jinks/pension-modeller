//
//  NewContributionsViewController.swift
//  F1rstPension
//
//  Created by Daniel Jinks on 09/06/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit

class NewContributionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // dimensions
    let cornerRadius: CGFloat = 5.0
    var standardRowHeight: CGFloat {
        return 40.0
    }
    
    var standardSeparatorHeight: CGFloat {
        return self.view.frame.height * 0.03
    }
    
    
    // finding rows to select for current contributions rates
    var rowForEmployeeContributionRate: Int {
        for i in 0..<GlobalConstants.ContributionRateIncrements.count {
            if GlobalConstants.ContributionRateIncrements[i] == Double(currentDCPension!.memberContributionRate!) {
                return i
            }
        }
        return 0
    }
    var rowForEmployerContributionRate: Int {
        for i in 0..<GlobalConstants.ContributionRateIncrements.count {
            if GlobalConstants.ContributionRateIncrements[i] == Double(currentDCPension!.employerContributionRate!) {
                return i
            }
        }
        return 0
    }
    
    var inputStep: Int = 1
    
    // instruction box text
    var instructionBoxText: String {
        switch inputStep {
        case 1: return "Please use the controls below to enter your contribution rate (as a percentage of salary), and the rate paid by your employer if relevant."
        case 2: return "Please select the method by which you pay your pension contributions. Double tap on a method to find out more."
        case 3: return "When you pay pension contributions by salary sacrifice, your employer saves on its national insurance bill. Some employers choose to pass some or all of this saving on to employees. Please use the slider below to set the rate of 'NI payover', if relevant."
        case 4: return "Based on the selected inputs, the effective total contribution rate is around " + createPercentageNumberFormatter().string(from: currentDCPension!.totalContributionRate!)! + ". We will use this figure as a starting point in the modeller, but you can change it later."
        default: return ""
        }
    }
    
    
    // toggleButton statuses
    var showContsDetails = false
    var showCashIntoPotDetail = false
    
    var pickerData = GlobalConstants.ContributionRateIncrements
    
    //MARK: - outlets
    

    
    @IBOutlet weak var instructionsBoxLabel: UILabel!
    
    @IBOutlet weak var employeeContPicker: UIPickerView! {
        didSet {
            employeeContPicker.dataSource = self
            employeeContPicker.delegate = self
            employeeContPicker.selectRow(rowForEmployeeContributionRate, inComponent: 0, animated: false)
        }
    }
    
    @IBOutlet weak var employerContPicker: UIPickerView! {
        didSet {
            employerContPicker.dataSource = self
            employerContPicker.delegate = self
            employerContPicker.selectRow(rowForEmployerContributionRate, inComponent: 0, animated: false)
        }
    }
    
    @IBOutlet weak var contributionMethodSelector: UISegmentedControl! {
        didSet {
            if let method = currentDCPension!.paymentMethod {
                switch method {
                case GlobalConstants.DCPaymentMethods.NetPay: contributionMethodSelector.selectedSegmentIndex = 0
                case GlobalConstants.DCPaymentMethods.ReliefAtSource: contributionMethodSelector.selectedSegmentIndex = 1
                case GlobalConstants.DCPaymentMethods.SalarySacrifice: contributionMethodSelector.selectedSegmentIndex = 2
                default: contributionMethodSelector.selectedSegmentIndex = UISegmentedControlNoSegment
                }
            } else {
                contributionMethodSelector.selectedSegmentIndex = UISegmentedControlNoSegment
            }
        }
    }
    
    @IBOutlet weak var grossMonthlyContributionsLabel: UILabel!
    
    @IBOutlet weak var grossContsBox: UIView!
    @IBOutlet weak var separatorEOrContDetails: UIView! {
        didSet {
            separatorEOrContDetails.alpha = 0.0
        }
    }
    @IBOutlet weak var netContsBox: UIView!
    @IBOutlet weak var contCalcContainer: UIView!
    @IBOutlet weak var incomeTaxSavingLabel: UILabel!
    @IBOutlet weak var niSavingLabel: UILabel!
    @IBOutlet weak var taxToReclaimLabel: UILabel!
    @IBOutlet weak var netPensionCostLabel: UILabel!
    
    @IBOutlet weak var niPayoverSlider: UISlider! {
        didSet {
            if currentDCPension!.niPayoverProportion != nil {
                niPayoverSlider.value = Float(currentDCPension!.niPayoverProportion!)
            } else {
                niPayoverSlider.value = 0.0
            }
        }
    }
    @IBOutlet weak var niPayoverProportionLabel: UILabel!
    
    @IBOutlet weak var memberContributionsIntoPotLabel: UILabel!
    @IBOutlet weak var employerContributionsIntoPotLabel: UILabel!
    @IBOutlet weak var niPayoverIntoPotLabel: UILabel!
    @IBOutlet weak var totalIntoPotLabel: UILabel!
    
    @IBOutlet var viewsToRound: [UIView]! {
        didSet {
            for view in viewsToRound {
                view.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    @IBOutlet var viewsWithShadows: [UIView]! {
        didSet {
            for view in viewsToRound {
                view.layer.shadowColor = UIColor.black.cgColor
                view.layer.shadowOpacity = 0.4
                view.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }
    
    //MARK: - contstraints to animate / change
    
    @IBOutlet var pickerBoxHHeights: [NSLayoutConstraint]! {
        didSet {
            for pickerBoxHeight in pickerBoxHHeights {
                pickerBoxHeight.constant = standardRowHeight * 5.0
            }
        }
    }
    
    @IBOutlet weak var contributionMethodBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var niPayoverBoxHeight: NSLayoutConstraint!
    
    @IBOutlet weak var grossContributionsBoxHeight: NSLayoutConstraint!

    @IBOutlet weak var contributionCalcRow1Height: NSLayoutConstraint!
    @IBOutlet weak var contributionCalcRow2Height: NSLayoutConstraint!
    @IBOutlet weak var contributionCalcRow3Height: NSLayoutConstraint!
    
    @IBOutlet weak var netContributionsBoxHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cashIntoPotDetailRow1Height: NSLayoutConstraint!
    @IBOutlet weak var cashIntoPotDetailRow2Height: NSLayoutConstraint!
    @IBOutlet weak var cashIntoPotDetailRow3Height: NSLayoutConstraint!
    @IBOutlet weak var cashIntoPotResultRowHeight: NSLayoutConstraint!
    
    
    //MARK:- lifecycle and UI updating
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialiseUI()
    }

    func initialiseUI() {
        updateText()
        updateNumbers()
        setBoxHeights()
        setAlphas()
    }
    
    func updateUI() {
        updateText()
        updateNumbers()
        setBoxHeightsAnimated()
        setAlphasAnimated()
    }
    
    func updateText() {
        instructionsBoxLabel.text = instructionBoxText
    }
    
    func updateNumbers() {
        let formatter = createNumberFormatter(maxValue: 1.0, prefix: "£")
        formatter.minimumFractionDigits = 2
        
        if inputStep >= 2 {
            grossMonthlyContributionsLabel.text = " " + formatter.string(from: NSNumber(value: currentDCPension!.monthlyMemberContributions_Gross))! + " "
            if inputStep >= 3 {
                incomeTaxSavingLabel.text = "(" + formatter.string(from: NSNumber(value: currentDCPension!.monthlyImmediateTaxRelief))! + ")"
                niSavingLabel.text = "(" + formatter.string(from: NSNumber(value: currentDCPension!.monthlyNISaving))! + ")"
                taxToReclaimLabel.text = "(" + formatter.string(from: NSNumber(value: currentDCPension!.monthlyTaxReclaim))! + ")"
                netPensionCostLabel.text = " " + formatter.string(from: NSNumber(value: currentDCPension!.monthlyNetPensionCost))! + " "
                
                if currentDCPension!.niPayoverProportion != nil {
                niPayoverProportionLabel.text = createPercentageNumberFormatter().string(from: currentDCPension!.niPayoverProportion!)
                } else {
                    niPayoverProportionLabel.text = "0.0%"
                }
                
                memberContributionsIntoPotLabel.text = " " + formatter.string(from: NSNumber(value: currentDCPension!.monthlyMemberContributions_Gross))! + " "
                employerContributionsIntoPotLabel.text = " " + formatter.string(from: NSNumber(value: currentDCPension!.monthlyEmployerContributions))! + " "
                niPayoverIntoPotLabel.text = " " + formatter.string(from: NSNumber(value: currentDCPension!.monthlyNIPayover))! + " "
                totalIntoPotLabel.text = " " + formatter.string(from: NSNumber(value: currentDCPension!.totalIntoPot))! + " "
            }
        } else {
            grossMonthlyContributionsLabel.text = formatter.string(from: 0.0)
        }
    }
    
    func setBoxHeights() {
        contributionMethodBoxHeight.constant = heightForContsMethodInputBox
        niPayoverBoxHeight.constant = heightForNIPayoverInputBox

        grossContributionsBoxHeight.constant = heightForGrossContsBox
        
        contributionCalcRow1Height.constant = heightForContributionCalcRow1
        contributionCalcRow2Height.constant = heightForContributionCalcRow2
        contributionCalcRow3Height.constant = heightForContributionCalcRow3
        netContributionsBoxHeight.constant = heightForNetContsBox
        
        cashIntoPotDetailRow1Height.constant = heightForCashIntoPotDetailRow1
        cashIntoPotDetailRow2Height.constant = heightForCashIntoPotDetailRow2
        cashIntoPotDetailRow3Height.constant = heightForCashIntoPotDetailRow3
        cashIntoPotResultRowHeight.constant = heightForCashIntoPotResultRow
    }
    
    func setBoxHeightsAnimated() {
        UIView.animate(withDuration: 0.5, animations: {
            self.setBoxHeights()
            self.view.layoutIfNeeded()
        })
    }
    
    func setAlphas() {

        var targetAlpha: CGFloat = 0.0
        if showContsDetails { targetAlpha = 1.0 }
        
        print("in setAlphas. targetAlpha : \(targetAlpha)")
        
            separatorEOrContDetails.alpha = targetAlpha
            contCalcContainer.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: Float(targetAlpha))
            grossContsBox.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: Float(1.0 - targetAlpha))
            netContsBox.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: Float(1.0 - targetAlpha))
    }
    
    func setAlphasAnimated() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.setAlphas()
        }) 
    }
    
    
    //MARK:- IBactions
    
    @IBAction func contributionMethodSelected(_ sender: UISegmentedControl) {
        
        if currentDCPension!.paymentMethod == GlobalConstants.DCPaymentMethods.All[sender.selectedSegmentIndex] {
            let alert = UIAlertView()
            alert.title = currentDCPension!.paymentMethod!
            var msg = ""
            switch currentDCPension!.paymentMethod! {
            case GlobalConstants.DCPaymentMethods.NetPay: msg = Strings.NetPayDescription
            case GlobalConstants.DCPaymentMethods.ReliefAtSource: msg = Strings.ReliefAtSourceDescription
            case GlobalConstants.DCPaymentMethods.SalarySacrifice: msg = Strings.SalarySacrificeDescription
            default: break
            }
            alert.message = msg
            alert.addButton(withTitle: "OK")
            alert.show()
        } else {
            currentDCPension!.paymentMethod = GlobalConstants.DCPaymentMethods.All[sender.selectedSegmentIndex]
        }
        
        
        if currentDCPension!.paymentMethod! == GlobalConstants.DCPaymentMethods.SalarySacrifice {
            inputStep = max(inputStep, 3)
        } else {
            inputStep = max(inputStep, 4)
        }
        updateTotalContributionRate()
        updateUI()
    }

    @IBAction func toggleShowContDetails(_ sender: UIButton) {
        showContsDetails = !showContsDetails
        updateUI()
    }

    @IBAction func toggleShowCashIntoPotDetail(_ sender: UIButton) {
        print("in toggleShowCashIntoPot")
        showCashIntoPotDetail = !showCashIntoPotDetail
        updateUI()
    }
    
    //MARK:- picker view methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let l = UILabel()
        
        let percentFormatter = createPercentageNumberFormatter()
        l.text = percentFormatter.string(from: NSNumber(value: pickerData[row]))
        
        l.textAlignment = NSTextAlignment.center
        l.backgroundColor = GlobalConstants.ColorPalette.SecondaryColorDark
        l.font = UIFont(name: "Arial", size: 11.0)
        l.textColor = UIColor.black
        l.layer.cornerRadius = 5.0
        l.clipsToBounds = true
        return l
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return standardRowHeight * 0.7
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        inputStep = max(inputStep, 2)
        
        currentDCPension!.memberContributionRate = GlobalConstants.ContributionRateIncrements[employeeContPicker.selectedRow(inComponent: 0)] as NSNumber?
        currentDCPension!.employerContributionRate = GlobalConstants.ContributionRateIncrements[employerContPicker.selectedRow(inComponent: 0)] as NSNumber?

        updateTotalContributionRate()
        updateUI()
        
        // also check to unhide next step..... TODO
    }
    
    func updateTotalContributionRate() {
        let unroundedRate = Double(currentDCPension!.memberContributionRate!) + Double(currentDCPension!.employerContributionRate!) + currentDCPension!.monthlyNIPayover / currentUser!.monthlySalary
        var roundingDifference = 1.0
        var closestRate = 0.00
        for i in 0..<GlobalConstants.ContributionRateIncrements.count {
            if abs(unroundedRate - GlobalConstants.ContributionRateIncrements[i]) < roundingDifference {
                roundingDifference = abs(unroundedRate - GlobalConstants.ContributionRateIncrements[i])
                closestRate = GlobalConstants.ContributionRateIncrements[i]
            }
        }
        currentDCPension!.totalContributionRate = closestRate as NSNumber?
    }
    
    @IBAction func niPayoverSliderValueChanged(_ sender: UISlider) {
        niPayoverSlider.value = floor(niPayoverSlider.value * 20.0 + 1.0 / 40.0) / 20.0
        currentDCPension!.niPayoverProportion = Double(sender.value) as NSNumber?
        inputStep = max(inputStep, 4)
        updateTotalContributionRate()
        updateUI()
    }
    @IBAction func niPayoverIncrementerPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            niPayoverSlider.value = min(1.0, niPayoverSlider.value + 0.05)
        } else {
            niPayoverSlider.value = max(0.0, niPayoverSlider.value - 0.05)
        }
        currentDCPension!.niPayoverProportion = Double(niPayoverSlider.value) as NSNumber?
        inputStep = max(inputStep, 4)
        updateTotalContributionRate()
        updateUI()
    }
    
    @IBAction func changeInstructionPage(_ sender: UIButton) {
        switch sender.tag {
        case 0: inputStep = max(0, inputStep - 1)
        case 1: inputStep = min(4, inputStep + 1)
        default: break
        }
        if currentDCPension!.paymentMethod! != GlobalConstants.DCPaymentMethods.SalarySacrifice && inputStep == 3 {
            changeInstructionPage(sender)
        }
        updateUI()
    }
    
    
    //MARK: - calculated variables for layout constraints
    
    var heightForContsMethodInputBox: CGFloat {
        if inputStep >= 2 {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForNIPayoverInputBox: CGFloat {
        if inputStep >= 3 && currentDCPension!.paymentMethod! == GlobalConstants.DCPaymentMethods.SalarySacrifice  {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForGrossContsBox: CGFloat {
        if inputStep >= 2 {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForSeparatorEOrContDetails: CGFloat {
        if showContsDetails {
            return standardRowHeight * 2.0
        } else {
            return standardSeparatorHeight
        }
    }
    
    var heightForNetContsBox: CGFloat {
        if inputStep >= 3 {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForContributionCalcRow1: CGFloat {
        if !showContsDetails {
            return standardSeparatorHeight / 3.0
        } else if currentDCPension!.monthlyImmediateTaxRelief != 0.0 {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForContributionCalcRow2: CGFloat {
        if !showContsDetails {
            return standardSeparatorHeight / 3.0
        } else if currentDCPension!.monthlyNISaving != 0.0 {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForContributionCalcRow3: CGFloat {
        if !showContsDetails {
            return standardSeparatorHeight / 3.0
        } else if currentDCPension!.monthlyTaxReclaim != 0.0 {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForCashIntoPotDetailRow1: CGFloat {
        if inputStep >= 2 && showCashIntoPotDetail {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForCashIntoPotDetailRow2: CGFloat {
        if inputStep >= 2 && showCashIntoPotDetail {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForCashIntoPotDetailRow3: CGFloat {
        if currentDCPension!.paymentMethod! == GlobalConstants.DCPaymentMethods.SalarySacrifice && showCashIntoPotDetail {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForCashIntoPotResultRow: CGFloat {
        if inputStep >= 3 {
            return standardRowHeight
        } else {
            return 0.0
        }
    }

}
