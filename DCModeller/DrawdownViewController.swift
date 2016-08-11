//
//  DrawdownViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 27/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import Charts

class DrawdownViewController: UIViewController, ChartViewDelegate {

    var activeAssumption = 0
    let cornerRadius:CGFloat = 7.5
    let dataFinder = DataFinder()
    
    var sliderIncrementSize: Float {
        return 1.0 / Float(possibleSliderValues.count - 1)
    }
    
    var possibleSliderValues: [Float] {
        
        var vals = [Float]()
        switch activeAssumption {
        //cash amount
        case 0:
            for i in 0...100 {
                vals.append(Float(i)/100.0)
            }
        case 1:
            vals = GlobalConstants.DrawdownIncomeIncrements
        case 2:
            vals = [0,1]
        case 3:
            for i in 0...20 {
                vals.append(Float(i)/20)
            }
        default: break
        }
        return vals
    }
    
    var cashOver25pc: Bool {
        return Double(currentDCPension!.cashProportion!) > 0.25
    }
    
    @IBOutlet weak var drawdownChartView: CustomCombinedChartView! {
        didSet {
            drawdownChartView.delegate = self
        }
    }
    
    @IBOutlet var assumptionButtons: [UIButton]!
    @IBOutlet weak var cashProportionButton: UIButton!
    @IBOutlet weak var drawdownIncomeButton: UIButton!
    @IBOutlet weak var inflationProtectionButton: UIButton!
    @IBOutlet weak var investmentReturnButton: UIButton!
    
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

        //set drawdown income if not yet set
        if currentDCPension!.initialDrawdownIncome == nil {
            let fivePercentOfFund = Double(currentDCPension!.fundValueAtRetirement) * 0.05
            for i in 0..<GlobalConstants.DrawdownIncomeIncrements.count {
                if Double(GlobalConstants.DrawdownIncomeIncrements[i]) > fivePercentOfFund {
                    currentDCPension!.initialDrawdownIncome = GlobalConstants.DrawdownIncomeIncrements[i]
                    break
                }
            }
            
        }
        
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
        investmentReturnButton.setTitle(percentFormatter.stringFromNumber(Double(currentDCPension!.investmentReturnInDrawdown!)), forState: .Normal)
        
        percentFormatter.maximumFractionDigits = 0
        cashProportionButton.setTitle(percentFormatter.stringFromNumber(Double(currentDCPension!.cashProportion!)), forState: .Normal)
        
        var formatter = createNumberFormatter(maxValue: Double(currentDCPension!.initialDrawdownIncome!), prefix: "£")
        formatter.maximumFractionDigits = 1
        drawdownIncomeButton.setTitle(formatter.stringFromNumber(Double(currentDCPension!.initialDrawdownIncome!)), forState: .Normal)
        
        inflationProtectionButton.setTitle(Bool(currentDCPension!.incomeInflationaryIncreases!) ? "Yes" : "No", forState: .Normal)

        formatter = createNumberFormatter(maxValue: currentDCPension!.cashAmount, prefix: "£")
        
        cashTakenLabel.text = " Cash Lump Sum : " + formatter.stringFromNumber(currentDCPension!.cashAmount)! + "      "
        
        formatter = createNumberFormatter(maxValue: currentDCPension!.drawdownFundValuesAndIncome.incomes.first!, prefix: "£")
        
        if let highlight = drawdownChartView.highlighted.first {
            let highlightedAge = min(100,highlight.xIndex + Int(currentDCPension!.selectedRetirementAge!))
            incomeLabel.text = " Income at \(highlightedAge) : " + formatter.stringFromNumber(currentDCPension!.drawdownFundValuesAndIncome.incomes[highlightedAge - Int(currentDCPension!.selectedRetirementAge!)])! + " pa     "
        } else {
            incomeLabel.text = " Income at \(Int(currentDCPension!.selectedRetirementAge!)) : " + formatter.stringFromNumber(currentDCPension!.initialDrawdownIncome!)! + " pa     "
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
        let incomesAndFVs = currentDCPension!.drawdownFundValuesAndIncome
        
        drawdownChartView.setCombinedChart(currentDCPension!.agesFromRetirementAgeAsStrings, barValues: incomesAndFVs.incomes, lineValues: incomesAndFVs.fundValues, barValueUnit: "£", lineValueUnit: "£", maxBarValue: incomesAndFVs.incomes.first!, maxLineValue: incomesAndFVs.fundValues.first!, verticalLimit: dataFinder.getLifeExpectancyFromRetirement()!)
    }
    
    @IBAction func assumptionsSliderValueChanged(sender: AnyObject) {
        assumptionsSlider.value = Float(Int(assumptionsSlider.value / sliderIncrementSize + 0.5)) * sliderIncrementSize
        switch activeAssumption {
        case 0: currentDCPension!.cashProportion! = Double(assumptionsSlider.value)
        case 1: currentDCPension!.initialDrawdownIncome = possibleSliderValues[Int(assumptionsSlider.value / sliderIncrementSize + 0.5)]
        case 2: currentDCPension!.incomeInflationaryIncreases = Bool(assumptionsSlider.value)
        case 3: currentDCPension!.investmentReturnInDrawdown = Double(assumptionsSlider.value * 0.1)
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
        case 1:
            for i in 0..<GlobalConstants.DrawdownIncomeIncrements.count {
                if Double(GlobalConstants.DrawdownIncomeIncrements[i]) > Double(currentDCPension!.initialDrawdownIncome!) {
                    assumptionsSlider.value = Float(i - 1) * sliderIncrementSize
                    break
                }
            }
            
        case 2: assumptionsSlider.value = Float(currentDCPension!.incomeInflationaryIncreases!)
        case 3: assumptionsSlider.value = Float(currentDCPension!.investmentReturnInDrawdown!) * 10.0
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
