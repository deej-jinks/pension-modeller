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
            cashWarningTriangle.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var assumptionsSlider: UISlider!
    
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

        //set drawdown income if not yet set
        if currentDCPension!.initialDrawdownIncome == nil {
            let fivePercentOfFund = Double(currentDCPension!.fundValueAtRetirement) * 0.05
            for i in 0..<GlobalConstants.DrawdownIncomeIncrements.count {
                if Double(GlobalConstants.DrawdownIncomeIncrements[i]) > fivePercentOfFund {
                    currentDCPension!.initialDrawdownIncome = GlobalConstants.DrawdownIncomeIncrements[i] as NSNumber?
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
        investmentReturnButton.setTitle(percentFormatter.string(from: currentDCPension!.investmentReturnInDrawdown!), for: UIControlState())
        
        percentFormatter.maximumFractionDigits = 0
        cashProportionButton.setTitle(percentFormatter.string(from: currentDCPension!.cashProportion!), for: UIControlState())
        
        var formatter = createNumberFormatter(maxValue: Double(currentDCPension!.initialDrawdownIncome!), prefix: "£")
        formatter.maximumFractionDigits = 1
        drawdownIncomeButton.setTitle(formatter.string(from: currentDCPension!.initialDrawdownIncome!), for: UIControlState())
        
        inflationProtectionButton.setTitle(Bool(currentDCPension!.incomeInflationaryIncreases!) ? "Yes" : "No", for: UIControlState())

        formatter = createNumberFormatter(maxValue: currentDCPension!.cashAmount, prefix: "£")
        
        cashTakenLabel.text = " Cash Lump Sum : " + formatter.string(from: NSNumber(value: currentDCPension!.cashAmount))! + "      "
        
        formatter = createNumberFormatter(maxValue: currentDCPension!.drawdownFundValuesAndIncome.incomes.first!, prefix: "£")
        
        if let highlight = drawdownChartView.highlighted.first {
            let highlightedAge = min(100,highlight.x + Double(currentDCPension!.selectedRetirementAge!))
            incomeLabel.text = " Income at \(highlightedAge) : " + formatter.string(from: NSNumber(value: currentDCPension!.drawdownFundValuesAndIncome.incomes[Int(highlightedAge) - Int(currentDCPension!.selectedRetirementAge!)]))! + " pa     "
        } else {
            incomeLabel.text = " Income at \(Int(currentDCPension!.selectedRetirementAge!)) : " + formatter.string(from: currentDCPension!.initialDrawdownIncome!)! + " pa     "
        }
        
        if cashOver25pc && cashWarningTriangle.alpha == 0.0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.cashWarningTriangle.alpha = 1.0
                self.cashWarningTriangle.isUserInteractionEnabled = true
            })
        } else if !cashOver25pc && cashWarningTriangle.alpha != 0.0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.cashWarningTriangle.alpha = 0.0
                self.cashWarningTriangle.isUserInteractionEnabled = false
            })
        }
        
        drawGraph()
    }
    
    func drawGraph() {
        let incomesAndFVs = currentDCPension!.drawdownFundValuesAndIncome
        
        drawdownChartView.setCombinedChart(currentDCPension!.agesFromRetirementAgeAsStrings, barValues: incomesAndFVs.incomes, lineValues: incomesAndFVs.fundValues, barValueUnit: "£", lineValueUnit: "£", maxBarValue: incomesAndFVs.incomes.first!, maxLineValue: incomesAndFVs.fundValues.first!, verticalLimit: dataFinder.getLifeExpectancyFromRetirement()!)
    }
    
    @IBAction func assumptionsSliderValueChanged(_ sender: AnyObject) {
        assumptionsSlider.value = Float(Int(assumptionsSlider.value / sliderIncrementSize + 0.5)) * sliderIncrementSize
        switch activeAssumption {
        case 0: currentDCPension!.cashProportion! = NSNumber(value: Double(assumptionsSlider.value))
        case 1: currentDCPension!.initialDrawdownIncome = possibleSliderValues[Int(assumptionsSlider.value / sliderIncrementSize + 0.5)] as NSNumber?
        case 2: currentDCPension!.incomeInflationaryIncreases = NSNumber(value: assumptionsSlider.value)
        case 3: currentDCPension!.investmentReturnInDrawdown = Double(assumptionsSlider.value * 0.1) as NSNumber?
        default: break
        }
        
        updateUI()
    }
    
    @IBAction func assumptionButtonPressed(_ sender: UIButton) {
        activeAssumption = sender.tag
        for button in assumptionButtons {
            if button.tag == sender.tag {
                button.setBackgroundImage(UIImage(named: "orangeBall"), for: UIControlState())
                button.tintColor = GlobalConstants.ColorPalette.SecondaryColorLight
            } else {
                button.setBackgroundImage(UIImage(named: "greyBall"), for: UIControlState())
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
    
    @IBAction func assumptionStepButtonPressed(_ sender: UIButton) {
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

    @IBAction func showCashWarning(_ sender: UIButton) {
        let alert = UIAlertView()
        alert.title = "Warning: Cash Commutation"
        alert.message = "You have selected to take more than 25% of your fund as cash.\n\nThe usual tax free cash allowance is 25% of your fund.\n\nIf you take more than this, you might be taxed on the part of your fund above 25%."
        alert.addButton(withTitle: "OK")
        alert.show()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        updateUI()
    }
}
