//
//  NewContributionsViewController.swift
//  F1rstPension
//
//  Created by Daniel Jinks on 09/06/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit

class NewContributionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let cornerRadius: CGFloat = 5.0
    
    var employeeContributionRate = 0.0
    var employerContributionRate = 0.0
    
    var standardRowHeight: CGFloat {
        return 40.0
    }
    
    var standardSeparatorHeight: CGFloat {
        return self.view.frame.height * 0.03
    }
    
    var contributionMethodChosen = 0
    
    // first input made
    var contRateSelected = false
    
    // second input made
    var contMethodSelected = false
    
    // toggleButton statuses
    var showContsDetails = false
    var showCashIntoPotDetail = false
    
    var pickerData = GlobalConstants.ContributionRateIncrements
    
    //MARK: - outlets
    
    @IBOutlet weak var grossMonthlyContributionsLabel: UILabel!
    
    
    @IBOutlet weak var employeeContPicker: UIPickerView! {
        didSet {
            employeeContPicker.dataSource = self
            employeeContPicker.delegate = self
        }
    }
    
    @IBOutlet weak var employerContPicker: UIPickerView! {
        didSet {
            employerContPicker.dataSource = self
            employerContPicker.delegate = self
        }
    }
    
    @IBOutlet weak var grossContsBox: UIView!
    @IBOutlet weak var separatorEOrContDetails: UIView! {
        didSet {
            separatorEOrContDetails.alpha = 0.0
        }
    }
    @IBOutlet weak var netContsBox: UIView!
    
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
                view.layer.shadowColor = UIColor.blackColor().CGColor
                view.layer.shadowOpacity = 0.4
                view.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }
    
    @IBOutlet weak var contributionMethodSelector: UISegmentedControl!
    
    
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
    
    
    @IBOutlet weak var contCalcContainer: UIView!
    @IBOutlet weak var grossContributionsBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var separatorE_or_contDetails_height: NSLayoutConstraint!
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
        updateNumbers()
        setBoxHeights()
        setAlphas()
    }
    
    func updateUI() {
        updateNumbers()
        setBoxHeightsAnimated()
        setAlphasAnimated()
    }
    
    func updateNumbers() {
        let formatter = createNumberFormatter(maxValue: 1.0, prefix: "£")
        formatter.minimumFractionDigits = 2
        //grossMonthlyContributionsLabel.text = formatter.stringFromNumber(Double(currentDCPension!.totalContributionRate!) * Double(currentUser!.salary!) / 12.0)
    }
    
    func setBoxHeights() {
        contributionMethodBoxHeight.constant = heightForContsMethodInputBox
        niPayoverBoxHeight.constant = heightForNIPayoverInputBox

        grossContributionsBoxHeight.constant = heightForGrossContsBox
        separatorE_or_contDetails_height.constant = heightForSeparatorEOrContDetails
        netContributionsBoxHeight.constant = heightForNetContsBox
        
        cashIntoPotDetailRow1Height.constant = heightForCashIntoPotDetailRow1
        cashIntoPotDetailRow2Height.constant = heightForCashIntoPotDetailRow2
        cashIntoPotDetailRow3Height.constant = heightForCashIntoPotDetailRow3
        cashIntoPotResultRowHeight.constant = heightForCashIntoPotResultRow
    }
    
    func setBoxHeightsAnimated() {
        UIView.animateWithDuration(0.5, animations: {
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
        UIView.animateWithDuration(0.5) { 
            self.setAlphas()
        }
    }
    
    
    //MARK:- IBactions
    
    @IBAction func contributionMethodSelected(sender: UISegmentedControl) {
        
        contMethodSelected = true
        
        if sender.selectedSegmentIndex == contributionMethodChosen {
            let alert = UIAlertView()
            alert.title = "Info Box"
            alert.message = "Will show info on this contribution method."
            alert.addButtonWithTitle("OK")
            alert.show()
        } else {
            contributionMethodChosen = sender.selectedSegmentIndex
        }
        
        updateUI()
    }

    @IBAction func toggleShowContDetails(sender: UIButton) {
        showContsDetails = !showContsDetails
        updateUI()
    }

    @IBAction func toggleShowCashIntoPotDetail(sender: UIButton) {
        print("in toggleShowCashIntoPot")
        showCashIntoPotDetail = !showCashIntoPotDetail
        updateUI()
    }
    
    //MARK:- picker view methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let l = UILabel()
        
        let percentFormatter = createPercentageNumberFormatter()
        l.text = percentFormatter.stringFromNumber(pickerData[row])
        
        l.textAlignment = NSTextAlignment.Center
        l.backgroundColor = GlobalConstants.ColorPalette.SecondaryColorDark
        l.font = UIFont(name: "Arial", size: 11.0)
        l.textColor = UIColor.blackColor()
        l.layer.cornerRadius = 5.0
        l.clipsToBounds = true
        return l
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return standardRowHeight * 0.7
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        contRateSelected = true
        
        switch pickerView {
        case employeeContPicker: employeeContributionRate = Double(pickerData[row])
        case employerContPicker: employerContributionRate = Double(pickerData[row])
        default: break
        }
        
        currentDCPension!.totalContributionRate = employeeContributionRate + employerContributionRate

        updateUI()
        
        // also check to unhide next step..... TODO
    }
    
    //MARK: - calculated variables for layout constraints
    
    var heightForContsMethodInputBox: CGFloat {
        if contRateSelected {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForNIPayoverInputBox: CGFloat {
        if contributionMethodChosen == 2  { //salary sacrifice
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForGrossContsBox: CGFloat {
        if contRateSelected {
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
        if contMethodSelected {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForCashIntoPotDetailRow1: CGFloat {
        if contRateSelected && showCashIntoPotDetail {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForCashIntoPotDetailRow2: CGFloat {
        if contRateSelected && showCashIntoPotDetail {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForCashIntoPotDetailRow3: CGFloat {
        if contributionMethodChosen == 2 && showCashIntoPotDetail {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
    var heightForCashIntoPotResultRow: CGFloat {
        if contMethodSelected {
            return standardRowHeight
        } else {
            return 0.0
        }
    }
    
//    var heightForCashInDetailRow1: CGFloat {
//        if showCashIntoPotDetail && contMethodSelected {
//            return standardRowHeight
//        } else {
//            return 0.0
//        }
//    }
//    
//    var heightForCashInDetailRow2: CGFloat {
//        if showCashIntoPotDetail && contMethodSelected {
//            return standardRowHeight
//        } else {
//            return 0.0
//        }
//    }
//    
//    var heightForCashInDetailRow3: CGFloat {
//        if showCashIntoPotDetail && contributionMethodChosen == 2 {
//            return standardRowHeight
//        } else {
//            return 0.0
//        }
//    }
//    
//    var heightForCashInResultRow: CGFloat {
//        if contMethodSelected {
//            return standardRowHeight
//        } else {
//            return 0.0
//        }
//    }


}
