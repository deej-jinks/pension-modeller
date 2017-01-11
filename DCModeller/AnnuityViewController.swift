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
            cashWarningTriangle.isUserInteractionEnabled = false
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
                box.layer.shadowColor = UIColor.black.cgColor
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
        cashProportionButton.setTitle(percentFormatter.string(from: currentDCPension!.cashProportion!), for: UIControlState())
        spousePensionButton.setTitle(Double(currentDCPension!.annuitySpouseProportion!) == 0.0 ? "No" : "Yes", for: UIControlState())
        inflationProtectionButton.setTitle(Bool(currentDCPension!.incomeInflationaryIncreases!) ? "Yes" : "No", for: UIControlState())

        var formatter = createNumberFormatter(maxValue: currentDCPension!.cashAmount, prefix: "£")
        
        
        
        cashTakenLabel.text = " Cash Lump Sum : " + formatter.string(from: NSNumber(value: currentDCPension!.cashAmount))! + "      "
        
        formatter = createNumberFormatter(maxValue: 100, prefix: "£")
        //let hs = incomeChartView.hi
        if let highlight = incomeChartView.highlighted.first {
            let highlightedAge = Int(min(100,highlight.x))
            incomeLabel.text = " Income at \(highlightedAge) : " + formatter.string(from: NSNumber(value: dataFinder.getAnnuityIncome()![Int(highlightedAge) - Int(currentDCPension!.selectedRetirementAge!)]))! + " pa     "
        } else {
            incomeLabel.text = " Income at \(Int(currentDCPension!.selectedRetirementAge!)) : " + formatter.string(from: NSNumber(value: dataFinder.getAnnuityIncome()!.first!))! + " pa     "
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
        incomeChartView.setAnnuityIncomeBarChart(labels: currentDCPension!.agesFromRetirementAgeAsStrings, values: dataFinder.getAnnuityIncome()!, maxValue: dataFinder.getAnnuityIncome()!.first!, limitLine: dataFinder.getLifeExpectancyFromRetirement()!)
    }
    
    @IBAction func assumptionsSliderValueChanged(_ sender: AnyObject) {
        assumptionsSlider.value = Float(Int(assumptionsSlider.value / sliderIncrementSize + 0.5)) * sliderIncrementSize
        switch activeAssumption {
        case 0: currentDCPension!.cashProportion! = NSNumber(value: Double(assumptionsSlider.value))
        case 1: currentDCPension?.annuitySpouseProportion = Double(assumptionsSlider.value * 0.5) as NSNumber?
        case 2: currentDCPension!.incomeInflationaryIncreases = NSNumber(value: assumptionsSlider.value)
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
        case 1: assumptionsSlider.value = Float(currentDCPension!.annuitySpouseProportion!) / 0.5
        case 2: assumptionsSlider.value = Float(currentDCPension!.incomeInflationaryIncreases!)
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
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        updateUI()
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        updateUI()
    }
}
