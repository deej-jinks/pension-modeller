//
//  AnnuityViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 24/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import Charts

class AnnuityViewController: UIViewController, ChartViewDelegate {

    var activeAssumption = 0
    let cornerRadius:CGFloat = 7.5
    let dataFinder = DataFinder()
    
    var sliderIncrementSize: Float {
        switch activeAssumption {
        case 0: return 0.01
        case 1,2: return 1.0
        default: return 1.0
        }
    }
    
    var cashOver25pc: Bool {
        return Double(currentDCPension!.cashProportion!) > 0.25
    }
    
    @IBOutlet weak var cashProportionButton: UIButton!
    @IBOutlet weak var spousePensionButton: UIButton!
    @IBOutlet weak var inflationProtectionButton: UIButton!
    @IBOutlet var assumptionButtons: [UIButton]!
    
    @IBOutlet weak var incomeLabel: UILabel! {
        didSet {
            incomeLabel.layer.cornerRadius = cornerRadius
            incomeLabel.backgroundColor = GlobalConstants.ColorPalette.SecondaryColorExtraLight
            incomeLabel.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var cashTakenLabel: UILabel! {
        didSet {
            cashTakenLabel.layer.cornerRadius = cornerRadius
            cashTakenLabel.backgroundColor = GlobalConstants.ColorPalette.SecondaryColorLight
            cashTakenLabel.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var cashWarningTriangle: UIButton! {
        didSet {
            cashWarningTriangle.alpha = 0.0
            cashWarningTriangle.userInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var assumptionsSlider: UISlider!
    
    @IBOutlet weak var incomeChartView: CustomBarChartView! {
        didSet {
            incomeChartView.delegate = self
        }
    }
    
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
        print("in vDL, annuityVC. DCPension : \(currentDCPension!)")
        
        assumptionsSlider.value = Float(currentDCPension!.cashProportion!)

        let dummyButton = UIButton()
        dummyButton.tag = activeAssumption
        assumptionButtonPressed(dummyButton)
        
        updateUI()
        
        do {
            try AppDelegate.getContext().save()
        } catch {}
    }
    
    
    func updateUI() {
        assumptionsSlider.value = Float(Int(assumptionsSlider.value / sliderIncrementSize + 0.5)) * sliderIncrementSize
        
        let percentFormatter = createPercentageNumberFormatter()
        percentFormatter.maximumFractionDigits = 0
        cashProportionButton.setTitle(percentFormatter.stringFromNumber(Double(currentDCPension!.cashProportion!)), forState: .Normal)
        spousePensionButton.setTitle(Double(currentDCPension!.annuitySpouseProportion!) == 0.0 ? "No" : "Yes", forState: .Normal)
        inflationProtectionButton.setTitle(Bool(currentDCPension!.incomeInflationaryIncreases!) ? "Yes" : "No", forState: .Normal)

        var formatter = createNumberFormatter(maxValue: currentDCPension!.cashAmount, prefix: "£")
        
        
        
        cashTakenLabel.text = " Cash Lump Sum : " + formatter.stringFromNumber(currentDCPension!.cashAmount)! + "      "
        
        formatter = createNumberFormatter(maxValue: 100, prefix: "£")
        
        if let highlight = incomeChartView.highlighted.first {
            let highlightedAge = min(100,highlight.xIndex + Int(currentDCPension!.selectedRetirementAge!))
            incomeLabel.text = " Income at \(highlightedAge) : " + formatter.stringFromNumber(dataFinder.getAnnuityIncome()![highlightedAge - Int(currentDCPension!.selectedRetirementAge!)])! + " pa     "
        } else {
            incomeLabel.text = " Income at \(Int(currentDCPension!.selectedRetirementAge!)) : " + formatter.stringFromNumber(dataFinder.getAnnuityIncome()!.first!)! + " pa     "
        }

        if cashOver25pc && cashWarningTriangle.alpha == 0.0 {
            UIView.animateWithDuration(0.5, animations: {
                self.cashWarningTriangle.alpha = 1.0
                self.cashWarningTriangle.userInteractionEnabled = true
            })
        } else if !cashOver25pc && cashWarningTriangle.alpha != 0.0 {
            UIView.animateWithDuration(0.5, animations: {
                self.cashWarningTriangle.alpha = 0.0
                self.cashWarningTriangle.userInteractionEnabled = false
            })
        }
        
        drawGraph()
    }
    
    func drawGraph() {
        incomeChartView.setAnnuityIncomeBarChart(labels: currentDCPension!.agesFromRetirementAgeAsStrings, values: dataFinder.getAnnuityIncome()!, maxValue: dataFinder.getAnnuityIncome()!.first!, limitLine: dataFinder.getLifeExpectancyFromRetirement()!)
    }
    
    @IBAction func assumptionsSliderValueChanged(sender: AnyObject) {
        assumptionsSlider.value = Float(Int(assumptionsSlider.value / sliderIncrementSize + 0.5)) * sliderIncrementSize
        switch activeAssumption {
        case 0: currentDCPension!.cashProportion! = Double(assumptionsSlider.value)
        case 1: currentDCPension?.annuitySpouseProportion = Double(assumptionsSlider.value * 0.5)
        case 2: currentDCPension!.incomeInflationaryIncreases = Bool(assumptionsSlider.value)
        default: break
        }
        
        updateUI()
    }
    
    @IBAction func assumptionButtonPressed(sender: UIButton) {
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
        case 0: assumptionsSlider.value = Float(currentDCPension!.cashProportion!)
        case 1: assumptionsSlider.value = Float(currentDCPension!.annuitySpouseProportion!) / 0.5
        case 2: assumptionsSlider.value = Float(currentDCPension!.incomeInflationaryIncreases!)
        default: break
        }
    }
    
    @IBAction func assumptionStepButtonPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            assumptionsSlider.value -= sliderIncrementSize
            assumptionsSliderValueChanged(sender)
        case 1:
            assumptionsSlider.value += sliderIncrementSize
            assumptionsSliderValueChanged(sender)
        default: break
        }
        updateUI()
    }

    @IBAction func showCashWarning(sender: UIButton) {
        let alert = UIAlertView()
        alert.title = "Warning: Cash Commutation"
        alert.message = "You have selected to take more than 25% of your fund as cash.\n\nThe usual tax free cash allowance is 25% of your fund.\n\nIf you take more than this, you might be taxed on the part of your fund above 25%."
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        updateUI()
    }
}
